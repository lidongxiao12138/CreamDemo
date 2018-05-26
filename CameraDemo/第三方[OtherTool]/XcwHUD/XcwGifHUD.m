//
//  XcwGifHUD.m
//  WORX
//
//  Created by yons on 16/11/17.
//  Copyright © 2016年 Hbung. All rights reserved.
//

#import "XcwGifHUD.h"

@implementation XcwGifHUD

+ (XcwGifHUD*)sharedView {
    static dispatch_once_t once;

    static XcwGifHUD *sharedView;

    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
 
    return sharedView;

}

- (instancetype) initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:CGRectMake(SCREENWIDTH/2-40, SCREENHEIGHT/2-35, 80, 70)]) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius=5;
        UILabel * label = [[UILabel alloc]init];
        [label setText:@"WORX"];
        [label setTextColor:[UIColor orangeColor]];
        [label setFont:[UIFont boldSystemFontOfSize:30]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(self.mas_top);
//            make.centerX.equalTo(self);
//            make.height.mas_equalTo(self.frame.size.height-30);
//        }];
        NSArray *myImages = [NSArray arrayWithObjects:

                             [UIImage imageNamed:@"swipe1.png"],

                             [UIImage imageNamed:@"swipe2.png"],

                             [UIImage imageNamed:@"swipe3.png"],

                             nil];

        UIImageView *myAnimatedView = [[UIImageView alloc] init];

        myAnimatedView.animationImages = myImages;
        myAnimatedView.animationDuration=0.8f;
        myAnimatedView.animationRepeatCount = 0;

        [myAnimatedView startAnimating];

        [self addSubview:myAnimatedView];

        [myAnimatedView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.size.mas_equalTo(CGSizeMake(50, 15));
            make.center.equalTo(self);
//            make.top.equalTo(label.mas_bottom).with.offset(9);

            
        }];

    }
    return self;

}

 - (void)show{

    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews lastObject];
    [topView addSubview:self];

}



+ (void)showXcwGifHUD{


    [[XcwGifHUD sharedView] show];

}

 
- (void)hide{

  [self removeFromSuperview];

}

+ (void)HideXcwGifHUD{

    [[XcwGifHUD sharedView] hide ];

}


@end
