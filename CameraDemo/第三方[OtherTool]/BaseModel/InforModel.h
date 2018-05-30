//
//  InforModel.h
//  BookingCar
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 LiXiaoJing. All rights reserved.
//

#import "RYBaseModel.h"

@interface InforModel : RYBaseModel<NSCoding>

@property (nonatomic, copy)NSString * idTemp;
@property (nonatomic, copy)NSString * create_time;
@property (nonatomic, copy)NSString * portrait_image;
@property (nonatomic, copy)NSString * nick_name;
@property (nonatomic, copy)NSString * article_count;
@property (nonatomic, copy)NSString * mobile;
@property (nonatomic, copy)NSString * access_token;
@property (nonatomic, copy)NSString * company1;
@property (nonatomic, copy)NSString * company2;
@property (nonatomic, copy)NSString * email;
@property (nonatomic, copy)NSString * points;
@property (nonatomic, copy)NSString * job;
@property (nonatomic, copy)NSString * code;
@property (nonatomic, copy)NSString * gender;
@property (nonatomic, copy)NSString * role;
@property (nonatomic, copy)NSString * zone;
@property (nonatomic, copy)NSString * avatar;
@property (nonatomic, copy)NSString * password;
@property (nonatomic, copy)NSString * birthday;

@property (nonatomic, copy)NSString * driver_pic1;
@property (nonatomic, copy)NSString * driver_pic2;
@property (nonatomic, copy)NSString * driverCardNum;
@property (nonatomic, copy)NSString * driverPNum;

@property (nonatomic, copy)NSString * car_pic1;//车辆正面照
@property (nonatomic, copy)NSString * car_pic2;//车辆反面照

@property (nonatomic, assign)CLLocationCoordinate2D PointLatLngLocation;//初始的坐标
@property (nonatomic, copy)NSString * backgroud;//背景图片

/**
 提现密码
 */
@property (nonatomic, copy)NSString * draw_password;//提现密码

@property (nonatomic, copy)NSString * JobStr;
@property (nonatomic, copy)NSString * ReturnStr;
@property (nonatomic, copy)NSString * WeakStarStr;
@property (nonatomic, copy)NSString * GoodLtdStr;


@property (nonatomic, copy) NSString *msg;//是否入职


@end
