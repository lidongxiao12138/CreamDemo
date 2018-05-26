//
//  UIImageView+Zoom.m
//  设置图片最大缩放比例
//
//  Created by yyx on 15/9/19.
//  Copyright (c) 2015年 yyx. All rights reserved.
//

#import "UIImageView+Zoom.h"
#import <objc/runtime.h>

//配置类
@interface SGConfig : NSObject

/** 是否支持缩放,默认不可缩放 */
@property (nonatomic,assign) BOOL zoomable;
/** 最大缩放比例,默认无穷大 */
@property (nonatomic,assign) CGFloat maxScale;
/** 最小缩放比例,默认无穷小*/
@property (nonatomic,assign) CGFloat minScale;

/** 记录累计的缩放比例 */
@property (nonatomic,assign) CGFloat totalScale;
@end

@implementation SGConfig


@end

@implementation UIImageView (Zoom)

- (SGConfig *)config{
    SGConfig *config =  objc_getAssociatedObject(self, @"config");
    if (config == nil) {
        //没有就创建,并设置属性
        SGConfig *config = [[SGConfig alloc] init];
        config.maxScale = 1.0;
        config.minScale = 1.0;
        config.totalScale = 1.0;
        
        //关联到自身
        objc_setAssociatedObject(self, @"config", config, OBJC_ASSOCIATION_RETAIN);
    }
    return config;
}

- (void)setZoomable:(BOOL)zoomable{
    if (zoomable == NO) {
        self.userInteractionEnabled = NO;
        return;
    }
    
    //打开用户交互
    self.userInteractionEnabled = YES;
    self.config.zoomable = YES;
    
    //添加手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    [self addGestureRecognizer:pinchGesture];
}
//看这里,核心代码
- (void)zoom:(UIPinchGestureRecognizer *)recognizer{
    CGFloat scale = recognizer.scale;
    
    //放大情况
    if(scale > 1.0){
        if (self.config.maxScale != 1.0) {
            if(self.config.totalScale > self.config.maxScale) return;
        }
    }
    
    //缩小情况
    if (scale < 1.0) {
        if (self.config.minScale != 1.0) {
            if (self.config.totalScale < self.config.minScale) return;
        }
    }
    
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    self.config.totalScale *=scale;
    recognizer.scale = 1.0;
}
- (BOOL)zoomable{
    return self.config.zoomable;
}
- (void)setMaxScale:(CGFloat)maxScale{
    self.config.maxScale = maxScale;
}
- (CGFloat)maxScale{
    return self.config.maxScale;
}
- (void)setMinScale:(CGFloat)minScale{
    self.config.minScale = minScale;
}
- (CGFloat)minScale{
    return self.config.minScale;
}
@end
