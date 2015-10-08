//
//  UIViewController+SYSearchBar.m
//  Pods
//
//  Created by Sean Yue on 15/10/4.
//
//

#import "UIViewController+SYSearchBar.h"
#import "UIImage+SYSearchBarExtensions.h"
#import "SYSearchButton.h"
#import <objc/runtime.h>

static void *kSearchButtonAssociatedKey = &kSearchButtonAssociatedKey;
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
    self.sySearchResultsViewController.view.frame = CGRectMake(self.view.bounds.origin.x,
                                                               self.view.bounds.origin.y + 20,
                                                               self.view.bounds.size.width,
                                                               self.view.bounds.size.height - 20);
    [self addChildViewController:self.sySearchResultsViewController];
    [self willMoveToParentViewController:nil];
//    self.sySearchResultsViewController.view.frame = CGRectMake(0, 20, 100, 100);
    
//    [self addChildViewController:self.sySearchResultsViewController];
//    [self.view addSubview:self.sySearchResultsViewController.view];
//    [self.sySearchResultsViewController.view willMoveToSuperview:self.view];

   // [self presentViewController:self.sySearchResultsViewController animated:YES completion:nil];
//    if (NSClassFromString(@"UISearchController")) {
//        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self.sySearchResultsViewController];
//        searchController.searchBar.backgroundColor = [UIColor clearColor];
//        searchController.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor redColor]];
//        searchController.searchBar.translucent = NO;
//        searchController.searchBar.barTintColor = [UIColor whiteColor];
//        searchController.active = YES;
//        [self presentViewController:searchController animated:YES completion:nil];
//    }
}

- (void)syBeginSearch {
    [self syShowSearchController];
}

#pragma mark - Setters/Getters of Properties

- (SYSearchButton *)sySearchButton {
    SYSearchButton *button = objc_getAssociatedObject(self, kSearchButtonAssociatedKey);
    if (button) {
        return button;
    }
    
    SYSearchButton *searchButton = [[SYSearchButton alloc] init];
    objc_setAssociatedObject(self, kSearchButtonAssociatedKey, searchButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    __weak typeof(self) weakSelf = self;
    searchButton.action = ^(SYSearchButton *button) {
        [weakSelf syBeginSearch];
    };
    
    return searchButton;
}

- (UIViewController *)sySearchResultsViewController {
    return objc_getAssociatedObject(self, kSearchResultsViewControllerAssociatedKey);
}

- (void)setSySearchResultsViewController:(UIViewController *)sySearchResultsViewController {
    objc_setAssociatedObject(self, kSearchResultsViewControllerAssociatedKey, sySearchResultsViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
