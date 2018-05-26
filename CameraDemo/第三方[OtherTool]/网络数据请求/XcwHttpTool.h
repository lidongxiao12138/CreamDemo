//
//  XcwHttpTool.h
//  WORX
//
//  Created by yons on 16/11/12.
//  Copyright © 2016年 Hbung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface XcwHttpTool : NSObject

+ (AFHTTPSessionManager *)manager ;
// 单例
+ (instancetype) sharedInstance;

// GET获取数据
+ (void)GetDataWithUrl:(NSString *)url TimeoutInterval:(CGFloat)interval Parameter:(NSDictionary *)parameter Success:(void (^)(id json))success  Failure:(void (^) (NSError * error))failure;

// POST上传普通数据
+ (void)PostDataWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

// 上传图片,不提示进度
+ (void)PostImages:(NSString *)url Parameters:(NSDictionary *)parameters ImageKeys:(NSMutableArray *)imgkeys Imagedatas:(NSArray *)imagedatas Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

// 上传大文件，在setUploadProgress bolok当返回上传进度数据，供view调用
+ (void)PostProgressWithURL:(NSString *)url Parameters:(NSDictionary *)parameters ConstructingBody:(void (^)(id<AFMultipartFormData> formData))constructingBody Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure SetUploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))setUploadProgress;


@end
