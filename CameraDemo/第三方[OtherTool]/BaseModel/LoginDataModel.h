//
//  LoginDataModel.h
//  BookingCar
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "RYBaseModel.h"
#import "InforModel.h"
#import "LoginModel.h"
@interface LoginDataModel : RYBaseModel
@property(nonatomic,strong)InforModel *inforModel;
@property(nonatomic,strong)LoginModel *loginInModel;
+ (instancetype)sharedManager;

//本地方法
-(void)saveLoginMemberData:(InforModel *)model;//储存用户信息
-(void)saveLoginInData:(LoginModel *)model;// 储存登录信息
-(void)logout;
-(BOOL)isLogined;

@end
