//
//  UIImage+ColorAtPixel.h
//  CameraDemo
//
//  Created by edz on 2018/5/4.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorAtPixel)
- (UIColor *)colorAtPixel:(CGPoint)point;
- (UIColor*)mostColor:(UIImage*)image;
@end
