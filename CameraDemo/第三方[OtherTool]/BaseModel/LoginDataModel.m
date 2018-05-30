//
//  LoginDataModel.m
//  BookingCar
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 LDX. All rights reserved.
//

#import "LoginDataModel.h"
@implementation LoginDataModel
@synthesize inforModel,loginInModel;
#define kCodeDownloaderKey          @"CodeDownloaderKey"

-(id)init{
    if(self = [super init])
    {
        //读取本地用户信息
        NSString *userDataFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginUserDataFile];
        
        self.inforModel = [NSKeyedUnarchiver unarchiveObjectWithFile:userDataFilePath];
        if(nil == inforModel)
        {
            inforModel = [[InforModel alloc] init];
        }
        
        //读取toknen值
        NSString *userLoginInFilePtah =[DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginInDataFile];
        self.loginInModel = [NSKeyedUnarchiver unarchiveObjectWithFile:userLoginInFilePtah];
        if (nil ==loginInModel) {
            loginInModel = [[LoginModel alloc]init];
        }
    }
    return self;
}
+ (instancetype)sharedManager
{
    static LoginDataModel *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LoginDataModel alloc] init];
    });
    return manager;
}

- (void)dealloc
{
    [[RYDownloaderManager sharedManager] cancelDownloaderWithDelegate:self purpose:nil];
}

#pragma mark -Public Methods
- (void)saveLoginMemberData:(InforModel *)model
{
    //保存登录用户信息
    NSData *memberData = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSString *userDataFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginUserDataFile];
    [memberData writeToFile:userDataFilePath atomically:NO];
    self.inforModel =model;
}

-(void)saveLoginInData:(LoginModel *)model
{
    //保存是否登陆信息
    NSData *loginInData = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSString *userDataFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:kLoginInDataFile];
    [loginInData writeToFile:userDataFilePath atomically:NO];
    self.loginInModel = model;
}

-(BOOL)isLogined
{
    if (self.loginInModel.token.length>0)
        return YES;
    return NO;
}
-(void)logout
{
    
}

@end
