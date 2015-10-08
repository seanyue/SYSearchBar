//
//  UIImage+SYSearchBarExtensions.m
//  Pods
//
//  Created by Sean Yue on 15/10/6.
//
//

#import "UIImage+SYSearchBarExtensions.h"

@implementation UIImage (SYSearchBarExtensions)

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
