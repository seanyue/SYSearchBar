//
//  SYSearchButton.m
//  Pods
//
//  Created by Sean Yue on 15/10/7.
//
//

#import "SYSearchButton.h"
#import "UIImage+SYSearchBarExtensions.h"
#import "SYSearchButton+Animation.h"

@interface SYSearchButton ()

@end

@implementation SYSearchButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.3].CGColor;
        self.layer.borderWidth = 2;
        self.layer.masksToBounds = YES;
        self.layer.anchorPoint = CGPointMake(0, 0.5);
        self.automaticallyAdjustCornerRadius = YES;
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.8 alpha:1.0]] forState:UIControlStateHighlighted];
        [self addTarget:self action:@selector(actionTap) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadImage];
        
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16.];
        _placeholderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.];
        [self addSubview:_placeholderLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.automaticallyAdjustCornerRadius) {
        self.layer.cornerRadius = [self cornerRadiusForButtonExpanded:self.expanded];
    }
    
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGFloat imageSize = MIN(contentRect.size.width, contentRect.size.height);
    _iconImageView.frame = CGRectInset(CGRectMake(contentRect.origin.x, contentRect.origin.y, imageSize, imageSize), imageSize*0.25, imageSize*0.25) ;
    
    self.placeholderLabel.hidden = !self.expanded;
    
    const CGFloat interspace = 5;
    _placeholderLabel.frame = CGRectMake(contentRect.origin.x+imageSize+interspace,
                                         contentRect.origin.y,
                                         contentRect.size.width - imageSize - interspace,
                                         contentRect.size.height);
}

- (void)loadImage {
    NSBundle *bundlePath = [NSBundle bundleForClass:[self class]];
    NSUInteger scale = [UIScreen mainScreen].scale;
    
    NSString *imageFile = [NSString stringWithFormat:@"search@%dx", scale > 2 ? 3:2];
    NSString *imagePath = [bundlePath pathForResource:imageFile ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    _iconImageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_iconImageView];
}

- (void)actionTap {
    [self beginSearchAnimation];
}

- (void)animateToPreviousPosition {
    [self endSearchAnimation];
}

- (void)setExpanded:(BOOL)expanded {
    [self setExpanded:expanded animated:YES];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (_expanded == expanded) {
        return ;
    }
    
    _expanded = expanded;
    
    if (animated) {
        [self animatedToExpanded:expanded];
    } else {
        [self layerSetExpanded:expanded];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    _placeholderLabel.text = placeholder;
}
@end
