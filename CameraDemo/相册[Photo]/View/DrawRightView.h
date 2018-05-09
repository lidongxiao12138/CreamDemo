//
//  DrawRightView.h
//  CameraDemo
//
//  Created by edz on 2018/5/3.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawRightView : UIView

@property (nonatomic, strong)UIColor * ImgColor;


-(void)getInfoArrayRight:(NSDictionary *)RightArr CGFloatScale:(CGFloat)scale CGFloatoffsetX:(CGFloat)offsetX CGFloatoffsetY:(CGFloat)offsetY;

@end
