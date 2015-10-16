//
//  SYAnimationHelper.h
//  Pods
//
//  Created by Sean Yue on 15/10/14.
//
//

#import <Foundation/Foundation.h>

@interface SYAnimationHelper : NSObject

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName;

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue;

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue
                                       delegate:(id)delegate;

+ (CABasicAnimation *)basicAnimationWithKeyPath:(NSString *)keyPath
                             timingFunctionName:(NSString *)timingFuncName
                                      fromValue:(id)fromValue
                                        toValue:(id)toValue
                                       delegate:(id)delegate
                                       duration:(NSTimeInterval)duration;
+ (CAAnimationGroup *)animationGroupWithAnimations:(NSArray<CAAnimation *> *)animations delegate:(id)delegate;
+ (CAAnimationGroup *)animationGroupWithAnimations:(NSArray<CAAnimation *> *)animations delegate:(id)delegate duration:(NSTimeInterval)duration;

+ (CGFloat)preferredAnimationDuration;

+ (void)animateView:(UIView *)view appearOnScreen:(BOOL)appear completion:(void (^)(BOOL finished))completion;

@end

#define SYBasicEaseInOrOutAnimation(easeIn,keyPath,fValue,tValue) \
    [SYAnimationHelper basicAnimationWithKeyPath:keyPath timingFunctionName:easeIn?kCAMediaTimingFunctionEaseIn:kCAMediaTimingFunctionEaseOut fromValue:fValue toValue:tValue]

#define SYBasicEaseInOrOutAnimationWithDuration(easeIn,keyPath,fValue,tValue,d) \
    [SYAnimationHelper basicAnimationWithKeyPath:keyPath timingFunctionName:easeIn?kCAMediaTimingFunctionEaseIn:kCAMediaTimingFunctionEaseOut fromValue:fValue toValue:tValue delegate:nil duration:d]

#define SYBasicEaseInAnimation(keyPath,fValue,tValue) \
    SYBasicEaseInOrOutAnimation(YES,keyPath,fValue,tValue)

#define SYBasicEaseOutAnimation(keyPath,fValue,tValue) \
    SYBasicEaseInOrOutAnimation(NO,keyPath,fValue,tValue)

#define CGPointValue(pt) \
    [NSValue valueWithCGPoint:pt]

#define CGPointXYValue(x,y) \
    [NSValue valueWithCGPoint:CGPointMake(x, y)]

#define CGRectValue(rect) \
    [NSValue valueWithCGRect:rect]

#define CGRectXYWHValue(x,y,w,h) \
    [NSValue valueWithCGRect:CGRectMake(x, y, w, h)]
