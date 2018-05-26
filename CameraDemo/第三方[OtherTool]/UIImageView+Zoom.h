//
//  UIImageView+Zoom.h
//  设置图片最大缩放比例
//
//  Created by yyx on 15/9/19.
//  Copyright (c) 2015年 yyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Zoom)

/** 是否支持缩放,默认不可缩放 */
@property (nonatomic,assign) BOOL zoomable;
/** 最大缩放比例,默认无穷大 */
@property (nonatomic,assign) CGFloat maxScale;
/** 最小缩放比例,默认无穷小*/
@property (nonatomic,assign) CGFloat minScale;

@end
