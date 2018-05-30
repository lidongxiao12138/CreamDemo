//
//  CameraViewController.m
//  CameraDemo
//
//  Created by edz on 2018/4/26.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FCDetectViewController.h"
#import "PhotoViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"
#import "SVProgressHUD.h"
#import <Photos/Photos.h>
#import "ZLDefine.h"
#import "FSKGPUImageBeautyFilter.h"
#define kScreenBounds   [UIScreen mainScreen].bounds

@interface CameraViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    BOOL OpenFlash;
    BOOL Protion;
}
@property (weak, nonatomic) IBOutlet UIView *ViewHead;//头部
@property (weak, nonatomic) IBOutlet UIButton *ButFlash;//闪光灯开关
@property (weak, nonatomic) IBOutlet UIButton *ButReverse;//反转摄像头

@property (weak, nonatomic) IBOutlet UIView *ViewPhoto;//相片位置

@property (weak, nonatomic) IBOutlet UIView *ViewFoot;//底部
@property (weak, nonatomic) IBOutlet UIButton *ButCancel;//取消
@property (weak, nonatomic) IBOutlet UIButton *ButPictures;//拍照
@property (weak, nonatomic) IBOutlet UIButton *ButPhoto;//相册
@property (weak, nonatomic) IBOutlet UIButton *ButSureClick;//确定
@property (weak, nonatomic) IBOutlet UIButton *ButGoBack;//返回
@property (weak, nonatomic) IBOutlet UIButton *ButProtion;//照片比例

@property(strong,nonatomic)GPUImageStillCamera *myCamera;
@property(strong,nonatomic)GPUImageView *myGPUImageView;
@property(strong,nonatomic)GPUImageFilter *myFilter;

@property (nonatomic,strong)GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,strong)GPUImageOutput<GPUImageInput> *filter1;
@property (nonatomic,strong)GPUImageFilterGroup *filterGroup;

@property(nonatomic,retain)AVCaptureSession * AVSession;

//CGImageRef cgref = [self.PhotoImage CGImage];
//if (cgref == NULL) {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        ZLOnePhoto *one = [ZLOnePhoto shareInstance];
//        [one presentPicker:PickerType_Photo photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
//            self.ImgPhoto.image = image;
//            self.PhotoImage = image;
//            if (isCancel == NO) {
//                [self requsetUpImage];
//            }else
//            {
//                [self dismissViewControllerAnimated:YES completion:^{
//                    self.ImgPhoto.image = nil;
//                }];
//            }
//
//        }];
//    });
//}else
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //inset code....
//        self.ImgPhoto.image = self.PhotoImage;
//        [self requsetUpImage];
//    });
//    //        [self handleImage:self.PhotoImage];
//}

@end

@implementation CameraViewController
- (void)viewWillAppear:(BOOL)animated{
    OpenFlash = YES;
    Protion = YES;

    [super viewWillAppear:animated];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customCamera];
    
    [self customUI];
}
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)customUI{
    
    //拍照
    [self.ButPictures addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    //取消
    [self.ButCancel addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    //反转
    [self.ButReverse addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    //闪光灯
    [self.ButFlash addTarget:self action:@selector(OpenFlashCream:) forControlEvents:UIControlEventTouchUpInside];
    //相册
    [self.ButPhoto addTarget:self action:@selector(ButPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    //照片比例
    [self.ButProtion addTarget:self action:@selector(ButProtionClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.ViewFoot];
    
    [self.view addSubview:self.ViewHead];
}
- (void)customCamera{
    
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化相机，第一个参数表示相册的尺寸，第二个参数表示前后摄像头
    self.myCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    //竖屏方向
    self.myCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.myCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.myCamera.horizontallyMirrorRearFacingCamera = NO;

    //精致美颜
    FSKGPUImageBeautyFilter * fskImage = [[FSKGPUImageBeautyFilter alloc]init];
    fskImage.brightLevel = 0.7;

    //初始化GPUImageView
    self.myGPUImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];

    //初始设置为哈哈镜效果
    [self.myCamera addTarget:fskImage];
    [fskImage addTarget:self.myGPUImageView];
    self.myFilter = fskImage;
    [self.ViewPhoto addSubview:self.myGPUImageView];
    [self.myCamera startCameraCapture];

}


-(void)OpenFlashCream:(UIButton *)sender
{
    OpenFlash = sender.selected;
    if (sender.selected == NO) {
        [sender setTitle:@"闪光灯打开" forState:UIControlStateNormal];
        sender.selected = YES;

    }else
    {
        sender.selected = NO;
        [sender setTitle:@"闪光灯关闭" forState:UIControlStateNormal];
    }
    
    
}


//闪光灯
- (void)FlashOn{

    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device.torchMode == AVCaptureTorchModeOff) {
        //Create an AV session
        AVCaptureSession * session = [[AVCaptureSession alloc]init];
        
        // Create device input and add to current session
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [session addInput:input];
        
        // Create video output and add to current session
        AVCaptureVideoDataOutput * output = [[AVCaptureVideoDataOutput alloc]init];
        [session addOutput:output];
        
        // Start session configuration
        [session beginConfiguration];
        [device lockForConfiguration:nil];
        
        // Set torch to on
        [device setTorchMode:AVCaptureTorchModeOn];
        
        [device unlockForConfiguration];
        [session commitConfiguration];
        
        // Start the session
        [session startRunning];
        
        // Keep the session around
        [self setAVSession:self.AVSession];
        }
}
//反转
- (void)changeCamera{
    [self.myCamera rotateCamera];
}
//相册
-(void)ButPhotoClick
{
    ZLOnePhoto *one = [ZLOnePhoto shareInstance];
    [one presentPicker:PickerType_Photo photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
        if (isCancel == NO) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               PhotoViewController * photo = [[PhotoViewController alloc]init];
                               photo.PhotoImage = image;
                               [self presentViewController:photo animated:NO completion:^{
                               }];
                           });
        }
    }];
    
}

-(void)ButProtionClick
{
    if (Protion == YES) {
        self.myCamera.captureSessionPreset = AVCaptureSessionPreset640x480;
        Protion = NO;
    }else
    {
       self.myCamera.captureSessionPreset = AVCaptureSessionPreset640x480;
        Protion = YES;
    }
}


#pragma mark - 拍照
//拍照
- (void) shutterCamera
{

    [self.myCamera capturePhotoAsImageProcessedUpToFilter:self.myFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        //拿到相册，需要引入Photo Kit
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil);
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               //写入图片到相册
                               PhotoViewController * photo = [[PhotoViewController alloc]init];
                               photo.PhotoImage = processedImage;
                               [self.myCamera startCameraCapture];
                               [self presentViewController:photo animated:NO completion:^{
                                   
                                   
                               }];
                           });
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
    }];
    
    
//    //定格一张图片 保存到相册
//    [self.myCamera capturePhotoAsPNGProcessedUpToFilter:self.myFilter withCompletionHandler:^(NSData *processedPNG, NSError *error) {
//
//        //拿到相册，需要引入Photo Kit
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//
//            UIImage * image = [UIImage imageWithData:processedPNG];
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//
//            dispatch_async(dispatch_get_main_queue(), ^
//            {
//                //写入图片到相册
//                PhotoViewController * photo = [[PhotoViewController alloc]init];
//                photo.PhotoImage = image;
//                [self.myCamera startCameraCapture];
//                [self presentViewController:photo animated:NO completion:^{
//
//
//                }];
//            });
//
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            NSLog(@"success = %d, error = %@", success, error);
//        }];
//    }];
    if (OpenFlash == NO ) {
        [self FlashOn];
    }
}


//取消
-(void)cancle{
    
    [self.myCamera startCameraCapture];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}



//#pragma mark - 检查相机权限
//- (BOOL)canUserCamear{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusDenied) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        alertView.tag = 100;
//        [alertView show];
//        return NO;
//    }
//    else{
//        return YES;
//    }
//    return YES;
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0 && alertView.tag == 100) {
//
//        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//
//        if([[UIApplication sharedApplication] canOpenURL:url]) {
//
//            [[UIApplication sharedApplication] openURL:url];
//
//        }
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
