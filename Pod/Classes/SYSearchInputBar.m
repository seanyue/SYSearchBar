//
//  SYSearchInputBar.m
//  Pods
//
//  Created by Sean Yue on 15/10/14.
//
//

#import "SYSearchInputBar.h"
#import "SYSearchButton+Animation.h"

static const CGFloat kCancelButtonWidth = 30;

@interface SYSearchInputBar ()

@end

@implementation SYSearchInputBar

- (instancetype)initFromSearchButton:(SYSearchButton *)searchButton {
    self = [super init];
    if (self) {
        self.backgroundColor = searchButton.backgroundColor;
        
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = searchButton.titleLabel.font;
        _inputTextField.placeholder = searchButton.placeholder;
        [self addSubview:_inputTextField];
        
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)actionCancel {
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
    
    _inputTextField.frame = CGRectMake([SYSearchButton placeholderLeftOffset], 0,
                                       CGRectGetMaxX(_cancelButton.frame)-[SYSearchButton placeholderLeftOffset]-kPadding,
                                       CGRectGetHeight(self.bounds));
    
}

@end
