//
//  SYSearchButton.m
//  Pods
//
//  Created by Sean Yue on 15/10/7.
//
//

#import "SYSearchButton.h"
#import "UIImage+SYSearchBarExtensions.h"

static NSString *const kExpandAnimationGroupKey = @"ExpandAnimationGroup";
static const CGFloat kAnimationDuration = 0.05;

@interface SYSearchButton ()
- (CGFloat)cornerRadiusForButtonExpanded:(BOOL)expanded;
- (CGRect)boundsForButtonExpanded:(BOOL)expanded;
@end

@implementation SYSearchButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.3].CGColor;
        self.layer.borderWidth = 2;
        self.layer.masksToBounds = YES;
        self.layer.anchorPoint = CGPointMake(0, 0.5);
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1.0]] forState:UIControlStateHighlighted];
        [self addTarget:self action:@selector(actionTap) forControlEvents:UIControlEventTouchUpInside];
        [self loadImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = [self cornerRadiusForButtonExpanded:self.expanded];
    self.titleLabel.hidden = !self.expanded;
}

- (void)loadImage {
    NSBundle *bundlePath = [NSBundle bundleForClass:[self class]];
    NSUInteger scale = [UIScreen mainScreen].scale;
    
    NSString *imageFile = [NSString stringWithFormat:@"search@%dx", scale > 2 ? 3:2];
    NSString *imagePath = [bundlePath pathForResource:imageFile ofType:@"png"];
    [self setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
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

- (void)actionTap {
    if (self.action) {
        __weak typeof(self) weakSelf = self;
        self.action(weakSelf);
    }
}

- (void)setExpanded:(BOOL)expanded {
    [self setExpanded:expanded animated:YES];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (_expanded == expanded) {
        return ;
    }
    
    _expanded = expanded;
    
    if (animated) {
        [self animatedToExpanded:expanded];
    } else {
        [self layerSetExpanded:expanded];
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
    }
    
    [self.layer removeAllAnimations];
}

- (void)animateToTopBarWithCompletion:(void (^)(void))completion {
    
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

- (void)setPlaceholder:(NSString *)placeholder {
    [self setTitle:placeholder forState:UIControlStateNormal];
}

- (NSString *)placeholder {
    return [self titleForState:UIControlStateNormal];
}

- (CGRect)contentRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 5);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageSize = MIN(contentRect.size.width, contentRect.size.height);
    return CGRectInset(CGRectMake(contentRect.origin.x, contentRect.origin.y, imageSize, imageSize), imageSize*0.25, imageSize*0.25) ;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat imageSize = MIN(contentRect.size.width, contentRect.size.height);
    const CGFloat interspace = 5;
    return CGRectMake(contentRect.origin.x+imageSize+interspace,
                      contentRect.origin.y,
                      contentRect.size.width - imageSize - interspace,
                      contentRect.size.height);
}
@end
