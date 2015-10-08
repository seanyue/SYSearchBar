//
//  UIViewController+SYSearchBar.h
//  Pods
//
//  Created by Sean Yue on 15/10/4.
//
//

#import <Foundation/Foundation.h>

@class SYSearchButton;

@interface UIViewController (SYSearchBar)

@property (nonatomic,retain,readonly) SYSearchButton *sySearchButton;
@property (nonatomic,retain) UIViewController *sySearchResultsViewController;

- (void)syAddSearchBarInPosition:(CGPoint)pos;

@end
