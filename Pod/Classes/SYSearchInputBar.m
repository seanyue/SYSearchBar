//
//  SYSearchInputBar.m
//  Pods
//
//  Created by Sean Yue on 15/10/14.
//
//

#import "SYSearchInputBar.h"
#import "SYSearchButton+Animation.h"
#import "UIImage+SYSearchBarExtensions.h"

static const CGFloat kCancelButtonWidth = 30;

@interface SYSearchInputBar ()

@end

@implementation SYSearchInputBar

- (instancetype)initFromSearchButton:(SYSearchButton *)searchButton {
    self = [super init];
    if (self) {
        self.backgroundColor = searchButton.backgroundColor;
        
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = searchButton.placeholderLabel.font;
        _inputTextField.placeholder = searchButton.placeholder;
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
        _inputTextField.returnKeyType = UIReturnKeySearch;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_inputTextField];
        
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithWhite:0.85 alpha:1] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)actionCancel {
    self.inputTextField.text = nil;
    if (self.cancelAction) {
        __weak typeof(self) weakSelf = self;
        self.cancelAction(weakSelf);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat kPadding = 10;
    
    _cancelButton.frame = CGRectMake(CGRectGetMaxX(self.bounds)-kCancelButtonWidth-kPadding,
                                     0,
                                     kCancelButtonWidth,
                                     CGRectGetHeight(self.bounds));
    _cancelButton.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        _cancelButton.alpha = 1;
    }];
    
    _inputTextField.frame = CGRectMake([SYSearchButton placeholderLeftOffset], 0,
                                       CGRectGetMinX(_cancelButton.frame)-[SYSearchButton placeholderLeftOffset]-kPadding,
                                       CGRectGetHeight(self.bounds));
    
}
@end
