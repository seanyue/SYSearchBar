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

static void *kInputBarTopInsetsAssociatedKey = &kInputBarTopInsetsAssociatedKey;
static void *kInputBarTopInsetsViewAssociatedKey = &kInputBarTopInsetsViewAssociatedKey;
static void *kSearchButtonAssociatedKey = &kSearchButtonAssociatedKey;
static void *kSearchInputBarAssociatedKey = &kSearchInputBarAssociatedKey;
static void *kSearchResultsViewControllerAssociatedKey = &kSearchResultsViewControllerAssociatedKey;

// KVO contexts
static void *kSearchButtonPlaceholderTextChangeContext = &kSearchButtonPlaceholderTextChangeContext;
static void *kSearchButtonPlaceholderFontChangeContext = &kSearchButtonPlaceholderFontChangeContext;

static const CGFloat kSearchButtonSize = 49.;

@interface UIViewController ()
@property (nonatomic,retain,readonly) UIView *syInputBarTopInsetsView;
@end

@implementation UIViewController (SYSearchBar)

- (void)syAddSearchBarInPosition:(CGPoint)pos {
    [self syAddSearchBarInPosition:pos topInsetsOfInputBar:0];
}

- (void)syAddSearchBarInPosition:(CGPoint)pos topInsetsOfInputBar:(CGFloat)topInsets {
    self.syInputBarTopInsets = topInsets;
    if (![self.view.subviews containsObject:self.sySearchButton]) {
        [self.view addSubview:self.sySearchButton];
    }
    
    self.sySearchButton.frame = CGRectMake(pos.x, pos.y, kSearchButtonSize, kSearchButtonSize);
}

- (void)syShowSearchController {
    CGFloat topInsets = CGRectGetHeight(self.sySearchInputBar.frame) + self.syInputBarTopInsets;
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

#pragma mark - SYSearchButtonDelegate

- (CGFloat)sySearchButtonTopBarInsets {
    return self.syInputBarTopInsets;
}

- (void)sySearchButtonWillAnimateToTopBar {
    [self syShowSearchController];

    if (self.syInputBarTopInsetsView) {
        self.syInputBarTopInsetsView.hidden = NO;
        self.syInputBarTopInsetsView.frame = CGRectMake(0, -self.syInputBarTopInsets,
                                                        self.view.bounds.size.width,
                                                        self.syInputBarTopInsets);
        [UIView animateWithDuration:[SYAnimationHelper preferredAnimationDuration] animations:^{
            self.syInputBarTopInsetsView.frame = CGRectMake(0, 0,
                                                            self.view.bounds.size.width,
                                                            self.syInputBarTopInsets);
        }];
    }
    
}

- (void)sySearchButtonDidAnimateToTopBar {
    if (![self.view.subviews containsObject:self.sySearchInputBar]) {
        [self.view addSubview:self.sySearchInputBar];
    }
    
    [self.sySearchInputBar setNeedsLayout];
    [self.sySearchInputBar.inputTextField becomeFirstResponder];
}

- (void)sySearchButtonWillAnimateToFloatingBar {
    if (self.syInputBarTopInsetsView) {
        [UIView animateWithDuration:[SYAnimationHelper preferredAnimationDuration] animations:^{
            self.syInputBarTopInsetsView.frame = CGRectMake(0, -self.syInputBarTopInsets,
                                                  self.view.bounds.size.width,
                                                  self.syInputBarTopInsets);
        } completion:^(BOOL finished) {
            self.syInputBarTopInsetsView.hidden = YES;
        }];
    }
    
    [SYAnimationHelper animateView:self.sySearchResultsViewController.view
                    appearOnScreen:NO
                        completion:^(BOOL finished) {
        [self.sySearchResultsViewController.view removeFromSuperview];
        [self.sySearchResultsViewController removeFromParentViewController];
    }];
}

#pragma mark - Setters/Getters of Properties

- (void)setSyInputBarTopInsets:(CGFloat)syInputBarTopInsets {
    objc_setAssociatedObject(self, kInputBarTopInsetsAssociatedKey, @(syInputBarTopInsets), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)syInputBarTopInsets {
    NSNumber *value = objc_getAssociatedObject(self, kInputBarTopInsetsAssociatedKey);
    return value.floatValue;
}

- (UIView *)syInputBarTopInsetsView {
    if (self.syInputBarTopInsets == 0) {
        return nil;
    }
    
    UIView *insetsView = objc_getAssociatedObject(self, kInputBarTopInsetsViewAssociatedKey);
    if (!insetsView) {
        insetsView = [[UIView alloc] init];
        [self.view addSubview:insetsView];
        objc_setAssociatedObject(self, kInputBarTopInsetsViewAssociatedKey, insetsView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
   // insetsView.frame = CGRectMake(0, -self.syInputBarTopInsets, self.view.bounds.size.width, self.syInputBarTopInsets);
    insetsView.backgroundColor = self.sySearchResultsViewController.view.backgroundColor;
    return insetsView;
    
}
- (SYSearchButton *)sySearchButton {
    SYSearchButton *button = objc_getAssociatedObject(self, kSearchButtonAssociatedKey);
    if (button) {
        return button;
    }
    
    SYSearchButton *searchButton = [[SYSearchButton alloc] init];
    searchButton.delegate = self;
    [searchButton addObserver:self forKeyPath:@"placeholderLabel.text" options:NSKeyValueObservingOptionNew context:kSearchButtonPlaceholderTextChangeContext];
    [searchButton addObserver:self forKeyPath:@"placeholderLabel.font" options:NSKeyValueObservingOptionNew context:kSearchButtonPlaceholderFontChangeContext];
    
    objc_setAssociatedObject(self, kSearchButtonAssociatedKey, searchButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return searchButton;
}

- (SYSearchInputBar *)sySearchInputBar {
    SYSearchInputBar *searchInputBar = objc_getAssociatedObject(self, kSearchInputBarAssociatedKey);
    if (searchInputBar) {
        return searchInputBar;
    }
    
    searchInputBar = [[SYSearchInputBar alloc] initFromSearchButton:self.sySearchButton];
    searchInputBar.frame = CGRectMake(0, self.syInputBarTopInsets, CGRectGetWidth(self.view.bounds), kSearchButtonSize);
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == kSearchButtonPlaceholderTextChangeContext) {
        self.sySearchInputBar.inputTextField.placeholder = change[@"new"];
    } else if (context == kSearchButtonPlaceholderFontChangeContext) {
        self.sySearchInputBar.inputTextField.font = change[@"new"];
    }
}
@end
