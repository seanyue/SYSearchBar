//
//  SYSearchButton.h
//  Pods
//
//  Created by Sean Yue on 15/10/7.
//
//

#import <UIKit/UIKit.h>

@class SYSearchButton;
typedef void (^SYSearchButtonAction)(SYSearchButton *button);

@interface SYSearchButton : UIButton

@property (nonatomic) NSString *placeholder;

@property (nonatomic) BOOL expanded;
@property (nonatomic,copy) SYSearchButtonAction action;

- (void)animateToTopBarWithCompletion:(void (^)(void))completion;

@end
