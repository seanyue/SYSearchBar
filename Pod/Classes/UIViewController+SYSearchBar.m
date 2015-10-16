//
//  UIViewController+SYSearchBar.m
//  Pods
//
//  Created by Sean Yue on 15/10/4.
//
//

#import "UIViewController+SYSearchBar.h"
#import "UIImage+SYSearchBarExtensions.h"
#import "SYAnimationHelper.h"
#import <objc/runtime.h>

static void *kSearchButtonAssociatedKey = &kSearchButtonAssociatedKey;
static void *kSearchInputBarAssociatedKey = &kSearchInputBarAssociatedKey;
static void *kSearchResultsViewControllerAssociatedKey = &kSearchResultsViewControllerAssociatedKey;

static const CGFloat kSearchButtonSize = 49.;

@implementation UIViewController (SYSearchBar)

- (void)syAddSearchBarInPosition:(CGPoint)pos {
    if (![self.view.subviews containsObject:self.sySearchButton]) {
        [self.view addSubview:self.sySearchButton];
    }
    
    self.sySearchButton.frame = CGRectMake(pos.x, pos.y, kSearchButtonSize, kSearchButtonSize);
}

- (void)syShowSearchController {
    CGFloat topInsets = CGRectGetHeight(self.sySearchInputBar.frame);
    CGRect targetFrame = CGRectMake(self.view.bounds.origin.x,
                                    self.view.bounds.origin.y + topInsets,
                                    self.view.bounds.size.width,
                                    self.view.bounds.size.height - topInsets);
    [self.view addSubview:self.sySearchResultsViewController.view];
    [self addChildViewController:self.sySearchResultsViewController];
    [self willMoveToParentViewController:nil];
    
    self.sySearchResultsViewController.view.frame = targetFrame;
    [SYAnimationHelper animateView:self.sySearchResultsViewController.view
                    appearOnScreen:YES
                        completion:nil];
}

- (void)syBeginSearch {
    [self syShowSearchController];
}

- (void)sySearchButtonWillAnimateToTopBar {
    [self syShowSearchController];
}

- (void)sySearchButtonDidAnimateToTopBar {
    if (![self.view.subviews containsObject:self.sySearchInputBar]) {
        [self.view addSubview:self.sySearchInputBar];
    }
    
    [self.sySearchInputBar setNeedsLayout];
    [self.sySearchInputBar.inputTextField becomeFirstResponder];
}

- (void)sySearchButtonWillAnimateToFloatingBar {
    [SYAnimationHelper animateView:self.sySearchResultsViewController.view
                    appearOnScreen:NO
                        completion:^(BOOL finished) {
        [self.sySearchResultsViewController.view removeFromSuperview];
        [self.sySearchResultsViewController removeFromParentViewController];
    }];
}

#pragma mark - Setters/Getters of Properties

- (SYSearchButton *)sySearchButton {
    SYSearchButton *button = objc_getAssociatedObject(self, kSearchButtonAssociatedKey);
    if (button) {
        return button;
    }
    
    SYSearchButton *searchButton = [[SYSearchButton alloc] init];
    searchButton.delegate = self;
    objc_setAssociatedObject(self, kSearchButtonAssociatedKey, searchButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return searchButton;
}

- (SYSearchInputBar *)sySearchInputBar {
    SYSearchInputBar *searchInputBar = objc_getAssociatedObject(self, kSearchInputBarAssociatedKey);
    if (searchInputBar) {
        return searchInputBar;
    }
    
    searchInputBar = [[SYSearchInputBar alloc] initFromSearchButton:self.sySearchButton];
    searchInputBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kSearchButtonSize);
    objc_setAssociatedObject(self, kSearchInputBarAssociatedKey, searchInputBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    __weak typeof(self) weakSelf = self;
    searchInputBar.cancelAction = ^(id sender){
        [weakSelf.sySearchInputBar removeFromSuperview];
        [weakSelf.sySearchButton animateToPreviousPosition];
    };
    
    return searchInputBar;
}

- (UIViewController *)sySearchResultsViewController {
    return objc_getAssociatedObject(self, kSearchResultsViewControllerAssociatedKey);
}

- (void)setSySearchResultsViewController:(UIViewController *)sySearchResultsViewController {
    objc_setAssociatedObject(self, kSearchResultsViewControllerAssociatedKey, sySearchResultsViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
