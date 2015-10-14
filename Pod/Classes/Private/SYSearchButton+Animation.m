//
//  SYSearchButton+Animation.m
//  Pods
//
//  Created by Sean Yue on 15/10/13.
//
//

#import "SYSearchButton+Animation.h"
#import <objc/runtime.h>

static NSString *const kExpandAnimationGroupKey = @"ExpandAnimationGroup";
static NSString *const kBeginSearchAnimationKey = @"BeginSearchAnimationKey";
static NSString *const kEndSearchAnimationKey = @"EndSearchAnimationKey";

static void *kAutomaticallyAdjustCornerRadiusAssociatedKey = &kAutomaticallyAdjustCornerRadiusAssociatedKey;
static void *kInSearchingAssociatedKey = &kInSearchingAssociatedKey;

static const CGFloat kAnimationDuration = 0.05;
static void *kLayerForTapAnimationAssociatedKey = &kLayerForTapAnimationAssociatedKey;
static const CGFloat kPlaceholderLeftOffset = 10;

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

- (BOOL)inSearching {
    NSNumber *value = objc_getAssociatedObject(self, kLayerForTapAnimationAssociatedKey);
    return value.boolValue;
}

- (void)setInSearching:(BOOL)inSearching {
    objc_setAssociatedObject(self, kLayerForTapAnimationAssociatedKey, @(inSearching), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//- (CALayer *)layerForTapAnimation {
//    CALayer *backgroundLayer = [CALayer layer];
//    backgroundLayer.backgroundColor = self.layer.backgroundColor;
//    backgroundLayer.frame = self.layer.frame;
//    backgroundLayer.cornerRadius = self.layer.cornerRadius;
//    [self.superview.layer addSublayer:backgroundLayer];
//    
////    UIGraphicsBeginImageContextWithOptions(self.titleLabel.bounds.size, self.titleLabel.opaque, 0.0);
////    [self.titleLabel drawViewHierarchyInRect:self.titleLabel.bounds afterScreenUpdates:NO];
////    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
//    
//    CATextLayer *textLayer = [CATextLayer layer];
//    textLayer.string = self.titleLabel.text;
//    textLayer.font = (__bridge CFTypeRef _Nullable)(self.titleLabel.font);
//    textLayer.frame = self.titleLabel.layer.frame;
//    textLayer.foregroundColor = self.titleLabel.textColor.CGColor;
//    textLayer.fontSize = self.titleLabel.font.pointSize;
//    
//    [backgroundLayer addSublayer:textLayer];
//    return backgroundLayer;
//}

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

- (void)animatedToExpanded:(BOOL)expanded {
    
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadiusAnimation.toValue = @([self cornerRadiusForButtonExpanded:expanded]);
    cornerRadiusAnimation.duration = kAnimationDuration;
    cornerRadiusAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    expandAnimation.duration = kAnimationDuration;
    expandAnimation.fillMode = kCAFillModeForwards;
    expandAnimation.toValue = [NSValue valueWithCGRect:[self boundsForButtonExpanded:expanded]];
    
    if (expanded) {
        cornerRadiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        expandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    } else {
        cornerRadiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        expandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[cornerRadiusAnimation,expandAnimation];
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = kAnimationDuration;
    [self.layer addAnimation:animationGroup forKey:kExpandAnimationGroupKey];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [self.layer animationForKey:kExpandAnimationGroupKey]) {
        [self layerSetExpanded:self.expanded];
    } else if (anim == [self.layer animationForKey:kBeginSearchAnimationKey]) {
        self.hidden = YES;
        [self.delegate sySearchButtonDidAnimateToTopbar];
        //self.hidden = YES;
    }
    
    [self.layer removeAllAnimations];
}

- (void)beginSearchAnimation {
    
    self.automaticallyAdjustCornerRadius = NO;
    self.inSearching = YES;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, self.bounds.size.height/2)];
    positionAnimation.duration = kAnimationDuration;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    expandAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.superview.bounds.size.width, self.bounds.size.height)];
    expandAnimation.duration = kAnimationDuration;
    expandAnimation.fillMode = kCAFillModeForwards;
    expandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, expandAnimation];
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = kAnimationDuration;
    
    [self.layer addAnimation:animationGroup forKey:kBeginSearchAnimationKey];
    
    CABasicAnimation *textPositionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    textPositionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.titleLabel.layer.position.x-CGRectGetMinX(self.titleLabel.frame)+kPlaceholderLeftOffset, self.titleLabel.layer.position.y)];
    textPositionAnimation.duration = kAnimationDuration;
    textPositionAnimation.fillMode = kCAFillModeForwards;
    textPositionAnimation.removedOnCompletion = NO;
    textPositionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.titleLabel.layer addAnimation:textPositionAnimation forKey:@"textPositionAnimation"];
}

- (void)endSearchAnimation {
    self.hidden = NO;
}

+ (CGFloat)placeholderLeftOffset {
    return kPlaceholderLeftOffset;
}
@end
