//
//  UIViewController+SYSearchBar.h
//  Pods
//
//  Created by Sean Yue on 15/10/4.
//
//

#import <Foundation/Foundation.h>
#import "SYSearchButton.h"
#import "SYSearchInputBar.h"

@protocol SYSearchBarDelegate <NSObject>

@optional
- (BOOL)sySearchBarShouldSearchKeywords:(NSString *)keywords;

@end

@interface UIViewController (SYSearchBar) <SYSearchButtonDelegate>

@property (nonatomic,readonly) CGFloat syInputBarTopInsets;

@property (nonatomic,retain,readonly) SYSearchButton *sySearchButton;
@property (nonatomic,retain,readonly) SYSearchInputBar *sySearchInputBar;
@property (nonatomic,retain) UIViewController *sySearchResultsViewController;
@property (nonatomic,weak) id<SYSearchBarDelegate> sySearchBarDelegate;

- (void)syAddSearchBarInPosition:(CGPoint)pos;
- (void)syAddSearchBarInPosition:(CGPoint)pos topInsetsOfInputBar:(CGFloat)topInsets;

@end
