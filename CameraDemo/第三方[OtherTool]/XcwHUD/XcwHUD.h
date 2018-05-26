//
//  XcwHUD.h
//  WORX
//
//  Created by yons on 16/11/12.
//  Copyright © 2016年 Hbung. All rights reserved.
//

#import "SVProgressHUD.h"

@interface XcwHUD : SVProgressHUD

#pragma 等待框
// 菊花等待提示框，允许用户操作
+ (void)showBasicChrysanthemumHUDAllowUserInteraction;

// 菊花等待提示框，不允许用户操作
+ (void)showBasicChrysanthemunHUDForbidUserInteraction;

// 菊花等待提示框，自定义颜色，允许用户操作
+ (void)showCustomChrysanthemumHUDAllowUserInteraction_bgColor:(UIColor *)bgcolor  foreColor:(UIColor *)forecolor ;

// 菊花等待提示框，自定义颜色及mask，不允许用户操作
+ (void)showCustomChrysanthemunHUDForbidUserInteraction_bgColor:(UIColor *)bgcolor  foreColor:(UIColor *)forecolor  maskType:(SVProgressHUDMaskType)type;

#pragma 成功信息
// 提示成功信息，黑色背景，允许用户操作
+ (void) showSuccessWithMessage:(NSString *)message;

// 提示成功信息，自定义背景，允许用户操作
+ (void) showSuccessWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor;

// 提示成功信息，自定义背景颜色和前景颜色，允许用户操作
+ (void) showSuccessWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor foreColor:(UIColor *)forecolor;

#pragma 错误信息
// 提示错误信息，黑色背景，允许用户操作
+ (void) showErrorWithMessage:(NSString *)message;

// 提示错误信息，自定义背景，允许用户操作
+ (void) showErrorsWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor;

// 提示错误信息，自定义背景颜色和前景颜色，允许用户操作
+ (void) showErrorWithMessage:(NSString *)message bgColor:(UIColor *)bgcolor foreColor:(UIColor *)forecolor;

+ (void) hide;

@end
