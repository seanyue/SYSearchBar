//
//  SYSearchButton+Animation.h
//  Pods
//
//  Created by Sean Yue on 15/10/13.
//
//

#import <Foundation/Foundation.h>
#import "SYSearchButton.h"

@interface SYSearchButton (Animation)

@property (nonatomic) BOOL automaticallyAdjustCornerRadius;

- (CGRect)boundsForButtonExpanded:(BOOL)expanded;
- (CGFloat)cornerRadiusForButtonExpanded:(BOOL)expanded;

- (void)animatedToExpanded:(BOOL)expanded;
- (void)layerSetExpanded:(BOOL)expanded;

- (void)beginSearchAnimation;
- (void)endSearchAnimation;

+ (CGFloat)placeholderLeftOffset;

@end
