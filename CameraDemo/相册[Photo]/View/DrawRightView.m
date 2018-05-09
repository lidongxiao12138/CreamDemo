//
//  DrawRightView.m
//  CameraDemo
//
//  Created by edz on 2018/5/3.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "DrawRightView.h"

@implementation DrawRightView
{
    NSDictionary * _arrayRight;
    CGFloat _OffsetX;
    CGFloat _OffsetY;
    CGFloat _Scale;
}

-(void)getInfoArrayRight:(NSDictionary *)RightArr CGFloatScale:(CGFloat)scale CGFloatoffsetX:(CGFloat)offsetX CGFloatoffsetY:(CGFloat)offsetY
{
    _arrayRight = RightArr;
    _OffsetX = offsetX;
    _OffsetY = offsetY;
    _Scale = scale;
}

- (void)drawRect:(CGRect)rect {
    
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = 5.0;
    
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [path moveToPoint:CGPointMake([_arrayRight[@"right_eyebrow_left_corner"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_left_corner"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_upper_left_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_upper_left_quarter"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_upper_middle"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_upper_middle"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_upper_right_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_upper_right_quarter"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_right_corner"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_right_corner"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_lower_right_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_lower_right_quarter"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_lower_middle"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_lower_middle"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_lower_right_quarter"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_lower_right_quarter"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path addLineToPoint:CGPointMake([_arrayRight[@"right_eyebrow_left_corner"][@"x"] floatValue]*_Scale+_OffsetX,[_arrayRight[@"right_eyebrow_left_corner"][@"y"] floatValue]*_Scale+_OffsetY)];
    
    [path closePath];//第五条线通过调用closePath方法得到的
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.ImgColor = RGBA(255, 255, 251, 1);
    shapeLayer.strokeColor= self.ImgColor.CGColor;
    shapeLayer.fillColor = self.ImgColor.CGColor;
    shapeLayer.opacity = 1;
    [self.layer addSublayer:shapeLayer];
    
    
//    [path fill];//颜色填充
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
