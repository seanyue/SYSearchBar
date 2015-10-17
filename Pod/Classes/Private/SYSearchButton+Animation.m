//
//  SYSearchButton+Animation.m
//  Pods
//
//  Created by Sean Yue on 15/10/13.
//
//

#import "SYSearchButton+Animation.h"
#import "SYAnimationHelper.h"
#import <objc/runtime.h>

static NSString *const kExpandAnimationGroupKey = @"ExpandAnimationGroup";
static NSString *const kBeginSearchAnimationKey = @"BeginSearchAnimationKey";
static NSString *const kEndSearchAnimationKey = @"EndSearchAnimationKey";
static NSString *const kImageAnimationKey = @"ImageAnimationKey";
static NSString *const kTextAnimationKey = @"TextAnimationKey";

static void *kAutomaticallyAdjustCornerRadiusAssociatedKey = &kAutomaticallyAdjustCornerRadiusAssociatedKey;

static void *kLayerForTapAnimationAssociatedKey = &kLayerForTapAnimationAssociatedKey;
static const CGFloat kPlaceholderLeftOffset = 15;

@interface SYSearchButton ()

@end

@implementation SYSearchButton (Animation)

- (BOOL)automaticallyAdjustCornerRadius {
    NSNumber *value = objc_getAssociatedObject(self, kAutomaticallyAdjustCornerRadiusAssociatedKey);
    return value.boolValue;
}

- (void)setAutomaticallyAdjustCornerRadius:(BOOL)automaticallyAdjustCornerRadius {
    objc_setAssociatedObject(self, kAutomaticallyAdjustCornerRadiusAssociatedKey, @(automaticallyAdjustCornerRadius), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)topBarInsets {
    if ([self.delegate respondsToSelector:@selector(sySearchButtonTopBarInsets)]) {
        return [self.delegate sySearchButtonTopBarInsets];
    }
    return 0;
}

- (CGFloat)cornerRadiusForButtonExpanded:(BOOL)expanded {
    CGFloat minSize = MIN(self.bounds.size.width, self.bounds.size.height);
    if (expanded) {
        return minSize / 20;
    } else {
        return minSize / 2;
    }
}

- (CGRect)boundsForButtonExpanded:(BOOL)expanded {
    CGFloat minSize = MIN(self.bounds.size.width, self.bounds.size.height);
    if (expanded) {
        return CGRectMake(self.bounds.origin.x,
                          self.bounds.origin.y,
                          self.superview.bounds.size.width-CGRectGetMinX(self.frame)*2,
                          self.bounds.size.height);
    } else {
        return CGRectMake(self.bounds.origin.x,
                          self.bounds.origin.y,
                          minSize, minSize);
    }
}

- (void)layerSetExpanded:(BOOL)expanded {
    self.layer.cornerRadius = [self cornerRadiusForButtonExpanded:self.expanded];
    
    if (expanded) {
        self.layer.frame = CGRectMake(self.frame.origin.x,
                                      self.frame.origin.y,
                                      self.superview.bounds.size.width-CGRectGetMinX(self.frame)*2,
                                      self.bounds.size.height);
    } else {
        CGFloat minSize = MIN(self.bounds.size.width, self.bounds.size.height);
        self.layer.frame = CGRectMake(self.frame.origin.x,
                                      self.frame.origin.y,
                                      minSize, minSize);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.iconImageView.layer animationForKey:kImageAnimationKey]) {
        self.iconImageView.alpha = 1;
        [self.iconImageView.layer removeAllAnimations];
        return ;
    }
    
    if (anim == [self.placeholderLabel.layer animationForKey:kTextAnimationKey]) {
        [self.placeholderLabel.layer removeAllAnimations];
        return ;
    }
    
    if (anim == [self.layer animationForKey:kExpandAnimationGroupKey]) {
        [self layerSetExpanded:self.expanded];
    } else if (anim == [self.layer animationForKey:kBeginSearchAnimationKey]) {
        self.hidden = YES;
        
        if ([self.delegate respondsToSelector:@selector(sySearchButtonDidAnimateToTopBar)]) {
            [self.delegate sySearchButtonDidAnimateToTopBar];
        }
    } else if (anim == [self.layer animationForKey:kEndSearchAnimationKey]) {
        if ([self.delegate respondsToSelector:@selector(sySearchButtonDidAnimateToFloatingBar)]) {
            [self.delegate sySearchButtonDidAnimateToFloatingBar];
        }
    }
    
    
    [self setNeedsLayout];
    [self.layer removeAllAnimations];
}

- (void)animatedToExpanded:(BOOL)expanded {
    
    static const NSTimeInterval kExpandAnimationDuration = 0.05;
    
    CGRect targetSelfBounds = [self boundsForButtonExpanded:expanded];
    
    NSArray<CAAnimation *> *animations =
  @[
    SYBasicEaseInOrOutAnimationWithDuration(expanded,@"cornerRadius",nil,@([self cornerRadiusForButtonExpanded:expanded]),kExpandAnimationDuration),
    SYBasicEaseInOrOutAnimationWithDuration(expanded,@"bounds",nil, CGRectValue(targetSelfBounds),kExpandAnimationDuration)
    ];
    
    [self.layer addAnimation:[SYAnimationHelper animationGroupWithAnimations:animations delegate:self duration:kExpandAnimationDuration] forKey:kExpandAnimationGroupKey];
}

- (void)beginSearchAnimation {
    if ([self.delegate respondsToSelector:@selector(sySearchButtonWillAnimateToTopBar)]) {
        [self.delegate sySearchButtonWillAnimateToTopBar];
    }
    
    self.automaticallyAdjustCornerRadius = NO;
    self.iconImageView.alpha = 0;
    
    NSArray<CAAnimation *> *animations =
  @[
    SYBasicEaseInAnimation(@"position", nil, CGPointXYValue(0, self.bounds.size.height/2+self.topBarInsets)),
    SYBasicEaseInAnimation(@"bounds", nil, CGRectXYWHValue(0, 0, self.superview.bounds.size.width, self.bounds.size.height)),
    SYBasicEaseInAnimation(@"cornerRadius", nil, @(0))
    ];
    
    [self.layer addAnimation:[SYAnimationHelper animationGroupWithAnimations:animations delegate:self] forKey:kBeginSearchAnimationKey];
    
    CABasicAnimation *textAnimation = SYBasicEaseInAnimation(@"position", nil,
                                                             CGPointXYValue(self.placeholderLabel.layer.position.x-CGRectGetMinX(self.placeholderLabel.frame)+kPlaceholderLeftOffset, self.placeholderLabel.layer.position.y));
    textAnimation.delegate = self;
    [self.placeholderLabel.layer addAnimation:textAnimation forKey:kTextAnimationKey];
}

- (void)endSearchAnimation {
    if ([self.delegate respondsToSelector:@selector(sySearchButtonWillAnimateToFloatingBar)]) {
        [self.delegate sySearchButtonWillAnimateToFloatingBar];
    }
    
    self.hidden = NO;
    self.automaticallyAdjustCornerRadius = YES;
    
    NSArray<CAAnimation *> *animations =
  @[
    SYBasicEaseOutAnimation(@"position", CGPointXYValue(0, self.bounds.size.height/2+self.topBarInsets), CGPointValue(self.layer.position)),
    SYBasicEaseOutAnimation(@"cornerRadius", @(0), @(self.layer.cornerRadius)),
    SYBasicEaseOutAnimation(@"bounds", CGRectXYWHValue(0, 0, self.superview.bounds.size.width, self.bounds.size.height), CGRectValue(self.layer.bounds))
    ];
    [self.layer addAnimation:[SYAnimationHelper animationGroupWithAnimations:animations delegate:self] forKey:kEndSearchAnimationKey];
    
    CABasicAnimation *textAnimation = SYBasicEaseOutAnimation(@"position",
                                                              CGPointXYValue(self.placeholderLabel.layer.position.x-CGRectGetMinX(self.placeholderLabel.frame)+kPlaceholderLeftOffset, self.placeholderLabel.layer.position.y),
                                                              CGPointValue(self.placeholderLabel.layer.position));
    textAnimation.delegate = self;
    [self.placeholderLabel.layer addAnimation:textAnimation forKey:kTextAnimationKey];
    
    CABasicAnimation *imageAnimation = SYBasicEaseOutAnimation(@"opacity", @(0), @(1));
    imageAnimation.delegate = self;
    [self.iconImageView.layer addAnimation:imageAnimation forKey:kImageAnimationKey];
}

+ (CGFloat)placeholderLeftOffset {
    return kPlaceholderLeftOffset;
}
@end
