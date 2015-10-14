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

- (void)sySearchButtonDidAnimateToTopbar;

@end

@interface SYSearchButton : UIButton

@property (nonatomic) NSString *placeholder;

@property (nonatomic) BOOL expanded;
@property (nonatomic,assign) id<SYSearchButtonDelegate> delegate;

- (void)animateToPreviousPosition;

@end
