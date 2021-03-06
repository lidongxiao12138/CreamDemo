//
//  LDXNetworking.m
//  BaseAppFrame
//
//  Created by 李东晓 on 2017/11/10.
//  Copyright © 2017年 LDX. All rights reserved.
//

#import "LDXNetworking.h"
#import "AFNetworking.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLRequestSerialization.h"
@implementation LDXNetworking
/** 单例声明 */
+ (instancetype)sharedInstance
{
    static LDXNetworking *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

/**
 *  网络监测(在什么网络状态)
 *
 *  @param unknown          未知网络
 *  @param reachable        无网络
 *  @param reachableViaWWAN 蜂窝数据网
 *  @param reachableViaWiFi WiFi网络
 */
- (void)networkStatusUnknown:(Unknown)unknown reachable:(Reachable)reachable reachableViaWWAN:(ReachableViaWWAN)reachableViaWWAN reachableViaWiFi:(ReachableViaWiFi)reachableViaWiFi;
{
    // 创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 监测到不同网络的情况
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                unknown();
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                reachable();
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                reachableViaWWAN();
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                reachableViaWiFi();
                break;
                
            default:
                break;
        }
    }] ;
    
    // 开始监听网络状况
    [manager startMonitoring];
}

/**
 *  封装的get请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    manager.requestSerializer.timeoutInterval = 20;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功的话
        if (success){
            success(responseObject);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败的话
        if (failure){
            failure(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

/**
 *  封装的POST请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    [cookieString appendFormat:@"SERVERID=%@;", @"0aeb8247c271f81ac58627137ad242b7|1626225140|1526218781"];
    [cookieString appendFormat:@"PHPSESSID=%@;", @"jp8f1t1mtkbt51lb7vouddfuk6"];
    
#warning 添加cookie
//    [manager.requestSerializer setValue:cookieString forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    manager.requestSerializer.timeoutInterval = 20;
    
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success){
            success(responseObject);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure){
            failure(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]; // 关闭状态栏动画
    }];
}

/**
 *  封装POST图片上传(单张图片)
 *
 *  @param URLString  上传接口
 *  @param parameters 上传参数
 *  @param img        上传图片
 *  @param imageName  自定义的图片名称（全部用字母写，不能出现汉字）
 *  @param fileName   由后台指定的图片名称
 *  @param progress   上传进度
 *  @param success    成功的回调方法
 *  @param failure    失败的回调方法
 */
- (void)UpLoadWithPOST:(NSString *)URLString parameters:(NSDictionary *)parameters image:(UIImage *)img imageName:(NSString *)imageName fileName:(NSString *)fileName progress:(Progress)progress success:(Success)success failure:(Failure)failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    [cookieString appendFormat:@"SERVERID=%@;", @"0aeb8247c271f81ac58627137ad242b7|1626225141|1526218781"];
    [cookieString appendFormat:@"PHPSESSID=%@;", @"jp8f1t1mtkbt51lb7vouddfuk6"];
#warning 添加cookie
//    [manager.requestSerializer setValue:cookieString forHTTPHeaderField:@"Cookie"];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/plain",
                                                         @"text/javascript",
                                                         @"text/json",
                                                         @"text/html",
                                                         @"image/jpeg", nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
    
    NSURLSessionDataTask *uploadTask = [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imgData = UIImageJPEGRepresentation(img,0.1);
        // 第一个name是后台给图片在服务器上起的字段名，第二个fileName是我们自己起的名字
        [formData appendPartWithFileData:imgData name:imageName fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    [uploadTask resume];
}

/**
 *  封装POST图片上传(多张图片) // 可扩展成多个别的数据上传如:mp3等
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param picArray   存放图片的数组
 *  @param progress   进度的回调
 *  @param success    发送成功的回调
 *  @param failure    发送失败的回调
 */
- (void)UpLoadWithPOST:(NSString *)URLString parameters:(NSDictionary *)parameters andPicArray:(NSArray *)picArray progress:(Progress)progress success:(Success)success failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/plain",
                                                         @"text/javascript",
                                                         @"text/json",
                                                         @"text/html",
                                                         @"image/jpeg", nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; // 开启状态栏动画
    
    NSURLSessionDataTask *uploadTask = [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage *img in picArray) {
            NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *fileName = [NSString stringWithFormat:@"%@-%ld.png",[formatter stringFromDate:[NSDate date]],[picArray indexOfObject:img]];
            [formData appendPartWithFileData:imgData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    [uploadTask resume];
}

/**
 *  下载
 *
 *  @param URLString       请求的链接
 *  @param progress        进度的回调
 *  @param downLoadPath    下载到的文件路径（可以为nil，默认是caches文件下）
 *  @param downLoadSuccess 发送成功的回调
 *  @param failure         发送失败的回调
 */
- (void)downLoadWithURL:(NSString *)URLString progress:(Progress)progress destination:(Destination)destination downLoadSuccess:(DownLoadSuccess)downLoadSuccess failure:(Failure)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (destination) {
            return destination(targetPath, response);
        }else{
            return nil;
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            downLoadSuccess(response, filePath);
        }else{
            failure(error);
        }
    }];
    
    // 开始启动任务
    [task resume];
}
@end
