//
//  SYSearchInputBar.h
//  Pods
//
//  Created by Sean Yue on 15/10/14.
//
//

#import <UIKit/UIKit.h>

@class SYSearchButton;

typedef void (^SYSearchInputBarCancelAction)(id sender);
typedef BOOL (^SYSearchInputBarSearchAction)(NSString *keywords);

@interface SYSearchInputBar : UIView

- (instancetype)initFromSearchButton:(SYSearchButton *)searchButton;

@property (nonatomic,retain,readonly) UITextField *inputTextField;
@property (nonatomic,retain,readonly) UIButton *cancelButton;

@property (nonatomic,copy) SYSearchInputBarSearchAction searchAction;
@property (nonatomic,copy) SYSearchInputBarCancelAction cancelAction;

@end
