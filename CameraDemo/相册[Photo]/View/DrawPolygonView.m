//
//  DrawPolygonView.m
//  UIBezierPathMethods
//
//  Created by 劉光軍 on 2016/11/9.
//  Copyright © 2016年 劉光軍. All rights reserved.
//

#import "DrawPolygonView.h"

@implementation DrawPolygonView
{
    NSDictionary * _arrayLeft;
    CGFloat _OffsetX;
    CGFloat _OffsetY;
    CGFloat _Scale;
    CAShapeLayer *shapeLayer;
}

-(void)getInfoArrayLift:(NSDictionary *)LiftArr CGFloatScale:(CGFloat)scale CGFloatoffsetX:(CGFloat)offsetX CGFloatoffsetY:(CGFloat)offsetY
{
    _arrayLeft = LiftArr;
    _OffsetX = offsetX;
    _OffsetY = offsetY;
    _Scale = scale;
}

- (void)drawRect:(CGRect)rect {
    [shapeLayer removeFromSuperlayer];
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 5.0;
    
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
        
    [path moveToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_left_corner"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_left_corner"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_upper_left_quarter"][@"x"] floatValue]*_Scale+_OffsetX - 15 *_Scale+_OffsetY,[_arrayLeft[@"left_eyebrow_upper_left_quarter"][@"y"] floatValue]*_Scale+_OffsetY - 15*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_upper_left_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_upper_left_quarter"][@"y"] floatValue]*_Scale+_OffsetY - 15*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_upper_middle"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_upper_middle"][@"y"] floatValue]*_Scale+_OffsetY - 15*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_upper_right_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_upper_right_quarter"][@"y"] floatValue]*_Scale+_OffsetY - 15*_Scale+_OffsetY)];
   
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_upper_right_quarter"][@"x"] floatValue]*_Scale+_OffsetX + 15 *_Scale+_OffsetY,[_arrayLeft[@"left_eyebrow_upper_right_quarter"][@"y"] floatValue]*_Scale+_OffsetY - 15*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_right_corner"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_right_corner"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_lower_right_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_lower_right_quarter"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_lower_middle"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_lower_middle"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_lower_right_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_lower_right_quarter"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayLeft[@"left_eyebrow_left_corner"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayLeft[@"left_eyebrow_left_corner"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path closePath];//第五条线通过调用closePath方法得到的
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.ImgColor = RGBA(247, 219, 207, 1);
    shapeLayer.strokeColor= self.ImgColor.CGColor;
    shapeLayer.fillColor = self.ImgColor.CGColor;
//    shapeLayer.opacity = 0.2;
    [self.layer addSublayer:shapeLayer];
    
        
//    [path fill];//颜色填充
    
}
@end
