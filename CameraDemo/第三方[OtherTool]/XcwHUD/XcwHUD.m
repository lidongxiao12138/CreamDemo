//
//  XcwHUD.m
//  WORX
//
//  Created by yons on 16/11/12.
//  Copyright © 2016年 Hbung. All rights reserved.
//

#import "XcwHUD.h"

@implementation XcwHUD
// 菊花等待提示框，允许用户操作
+ (void)showBasicChrysanthemumHUDAllowUserInteraction{


    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeNone)];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];

}

// 菊花等待提示框，不允许用户操作
+ (void)showBasicChrysanthemunHUDForbidUserInteraction{

    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeCustom)];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];

}

// 菊花等待提示框，自定义颜色，允许用户操作
+ (void)showCustomChrysanthemumHUDAllowUserInteraction_bgColor:(UIColor *)bgcolor  foreColor:(UIColor *)forecolor  {

    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:bgcolor];
    [SVProgressHUD setForegroundColor:forecolor];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];

}

// 菊花等待提示框，自定义颜色及mask，不允许用户操作
+ (void)showCustomChrysanthemunHUDForbidUserInteraction_bgColor:(UIColor *)bgcolor  foreColor:(UIColor *)forecolor  maskType:(SVProgressHUDMaskType)type{

    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setDefaultMaskType:(type)];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
}

// 提示成功信息，黑色背景，允许用户操作
+ (void) showSuccessWithMessage:(NSString *)message{

    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];

}

// 提示成功信息，自定义背景，允许用户操作
+ (void) showSuccessWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor{

    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
    [SVProgressHUD setBackgroundColor:bgcolor];
    
}

// 提示成功信息，自定义背景颜色和前景颜色，允许用户操作
+ (void) showSuccessWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor foreColor:(UIColor *)forecolor{

    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
    [SVProgressHUD setBackgroundColor:bgcolor];
    [SVProgressHUD setForegroundColor:forecolor];

}

// 提示错误信息，黑色背景，允许用户操作
+ (void) showErrorWithMessage:(NSString *)message{

    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];

}

// 提示错误信息，自定义背景，允许用户操作
+ (void) showErrorsWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor{

    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
    [SVProgressHUD setBackgroundColor:bgcolor];

}

// 提示错误信息，自定义背景颜色和前景颜色，允许用户操作
+ (void) showErrorWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor foreColor:(UIColor *)forecolor{

    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
    [SVProgressHUD setBackgroundColor:bgcolor];
    [SVProgressHUD setForegroundColor:forecolor];
    
}

+ (void)hide{

    [self dismiss];
}



@end
