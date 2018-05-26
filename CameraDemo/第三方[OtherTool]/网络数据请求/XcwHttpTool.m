//
//  XcwHttpTool.m
//  WORX
//
//  Created by yons on 16/11/12.
//  Copyright © 2016年 Hbung. All rights reserved.
//

#import "XcwHttpTool.h"
#import "XcwHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
@implementation XcwHttpTool

+ (instancetype) sharedInstance{

    static XcwHttpTool * _sharedInstance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedInstance = [[XcwHttpTool alloc] init];

    });
    return _sharedInstance;
}

+ (AFHTTPSessionManager *)manager {
    static AFHTTPSessionManager *manager = nil;
    if (manager == nil) {
        manager = [AFHTTPSessionManager manager];
    }
    return manager;
}

+ (void)GetDataWithUrl:(NSString *)url TimeoutInterval:(CGFloat)interval Parameter:(NSDictionary *)parameter Success:(void (^)(id json))success  Failure:(void (^) (NSError * error))failure{

    //显示状态栏的网络指示器

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager* manager =[AFHTTPSessionManager manager];
//    manager.requestSerializer.HTTPShouldHandleCookies=YES;
     //配置cookie
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:sessionCookie];
//    NSLog(@"cookiedata--= %@",cookiesdata);
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        }
//    } 

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/jpeg", @"image/png",@"application/octet-stream", @"text/json", @"text/plain",@"text/javascript",nil];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
     manager.requestSerializer.timeoutInterval = interval;//设置请求超时时间
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
 
    [manager GET:url parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        success(responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     
        failure(error);
    }];
}


// POST上传数据
+ (void)PostDataWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {

    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *mgr = [XcwHttpTool manager];
//    mgr.requestSerializer.HTTPShouldHandleCookies=YES;

    //配置cookie
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:sessionCookie];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//       
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        }
//    }

    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 30.0;//设置请求超时时间
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    mgr.responseSerializer= [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/jpeg", @"image/png",@"application/octet-stream", @"text/json", @"text/plain",@"text/javascript",nil];

    [mgr POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
}

// 上传图片，注意filename要以.jpg为后缀，否则后台若未作处理可能读取不了
+ (void)PostImages:(NSString *)url Parameters:(NSDictionary *)parameters ImageKeys:(NSMutableArray *)imgkeys Imagedatas:(NSArray *)imagedatas Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure {

    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *mgr = [self manager];
//    mgr.requestSerializer.HTTPShouldHandleCookies=YES;

    //设置加载时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 20.0;//设置请求超时时间
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    mgr.responseSerializer= [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"image/jpeg", @"image/png",@"application/octet-stream", @"text/json", @"text/plain",@"text/javascript",nil];

    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imgkeys.count > 0) {
            for (int i = 0; i < imgkeys.count; i++) {
                NSString *nameStr = [NSString stringWithFormat:@"image%lu.jpg",(unsigned long)imgkeys.count];
                NSData *imageData = imagedatas[i];
                [formData appendPartWithFileData:imageData name:imgkeys[i] fileName:nameStr mimeType:@"image/jpeg"];
            }
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];


}

// 上传大文件，在setUploadProgress bolok当返回上传进度数据，供view调用
+ (void)PostProgressWithURL:(NSString *)url Parameters:(NSDictionary *)parameters ConstructingBody:(void (^)(id<AFMultipartFormData> formData))constructingBody Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure SetUploadProgress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))setUploadProgress{

    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.requestSerializer.HTTPShouldHandleCookies=YES;
    //设置加载时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 600.0;//设置请求超时时间
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    mgr.responseSerializer= [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/jpeg", @"image/png",@"application/octet-stream", @"text/json", @"text/plain",@"text/javascript",nil];

    AFHTTPRequestOperation *fileUpload = [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        constructingBody(formData);
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(error);
    }];
    [fileUpload setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        setUploadProgress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    }];
}

@end
