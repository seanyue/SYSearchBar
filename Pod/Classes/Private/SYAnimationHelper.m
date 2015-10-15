//
//  SYAnimationHelper.m
//  Pods
//
//  Created by Sean Yue on 15/10/14.
//
//

#import "SYAnimationHelper.h"

static const CGFloat kAnimationDuration = 0.05;

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
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
    basicAnimation.duration = kAnimationDuration;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:timingFuncName];
    basicAnimation.fromValue = fromValue;
    basicAnimation.toValue = toValue;
    basicAnimation.delegate = delegate;
    return basicAnimation;
}

+ (CAAnimationGroup *)animationGroupWithAnimations:(NSArray<CAAnimation *> *)animations delegate:(id)delegate {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.delegate = delegate;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = kAnimationDuration;
    return animationGroup;
}
@end
