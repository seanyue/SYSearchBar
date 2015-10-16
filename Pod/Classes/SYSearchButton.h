//
//  SYSearchButton.h
//  Pods
//
//  Created by Sean Yue on 15/10/7.
//
//

#import <UIKit/UIKit.h>

@class SYSearchButton;

@protocol SYSearchButtonDelegate <NSObject>

@optional
- (CGFloat)sySearchButtonTopBarInsets;
- (void)sySearchButtonWillAnimateToTopBar;
- (void)sySearchButtonDidAnimateToTopBar;

- (void)sySearchButtonWillAnimateToFloatingBar;
- (void)sySearchButtonDidAnimateToFloatingBar;
@end

@interface SYSearchButton : UIButton

@property (nonatomic,readonly,retain) UIImageView *iconImageView;
@property (nonatomic,readonly,retain) UILabel *placeholderLabel;

@property (nonatomic) NSString *placeholder;

@property (nonatomic) BOOL expanded;
@property (nonatomic,assign) id<SYSearchButtonDelegate> delegate;

- (void)animateToPreviousPosition;

@end
