//
//  SYAnimationHelper.m
//  Pods
//
//  Created by Sean Yue on 15/10/14.
//
//

#import "SYAnimationHelper.h"

static const CGFloat kAnimationDuration = 0.15;

@implementation SYAnimationHelper

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName {
    return [self basicAnimationWithKeyPath:keyPath timingFunctionName:timingFuncName fromValue:nil toValue:nil delegate:nil];
}

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue {
    return [self basicAnimationWithKeyPath:keyPath timingFunctionName:timingFuncName fromValue:fromValue toValue:toValue delegate:nil];
}

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue
                                       delegate:(id)delegate {
    return [self basicAnimationWithKeyPath:keyPath timingFunctionName:timingFuncName fromValue:fromValue toValue:toValue delegate:delegate duration:kAnimationDuration];
}

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue
                                       delegate:(id)delegate
                                       duration:(NSTimeInterval)duration {
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
    basicAnimation.duration = kAnimationDuration;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timingFuncName];
    basicAnimation.fromValue = fromValue;
    basicAnimation.toValue = toValue;
    basicAnimation.delegate = delegate;
    basicAnimation.duration = duration;
    return basicAnimation;
}

+ (CAAnimationGroup *)animationGroupWithAnimations:(NSArray<CAAnimation *> *)animations delegate:(id)delegate {
    return [self animationGroupWithAnimations:animations delegate:delegate duration:kAnimationDuration];
}

+ (CAAnimationGroup *)animationGroupWithAnimations:(NSArray<CAAnimation *> *)animations delegate:(id)delegate duration:(NSTimeInterval)duration {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.delegate = delegate;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = duration;
    return animationGroup;
}

+ (CGFloat)preferredAnimationDuration {
    return kAnimationDuration;
}

+ (void)animateView:(UIView *)view appearOnScreen:(BOOL)appear completion:(void (^)(BOOL finished))completion {
    CGRect onScreenFrame = view.frame;
    CGRect outScreenFrame = CGRectOffset(onScreenFrame, 0, CGRectGetHeight(onScreenFrame));
    
    if (appear) {
        view.frame = outScreenFrame;
    }
    [UIView animateWithDuration:kAnimationDuration delay:0 options:appear?UIViewAnimationOptionCurveEaseIn:UIViewAnimationOptionCurveEaseOut animations:^{
        view.frame = appear ? onScreenFrame : outScreenFrame;
    } completion:completion];
}
@end
