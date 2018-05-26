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
@property(nonatomic,retain)AVCaptureSession * AVSession;



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
    self.myCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    
//    self.myCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    
    //竖屏方向
    self.myCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.myCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.myCamera.horizontallyMirrorRearFacingCamera = NO;
    
    //哈哈镜效果
    GPUImageStretchDistortionFilter *stretchDistortionFilter = [[GPUImageStretchDistortionFilter alloc] init];
    
    //亮度
    GPUImageBrightnessFilter *BrightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    
    //伽马线滤镜
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    
    //边缘检测
    GPUImageXYDerivativeFilter *XYDerivativeFilter = [[GPUImageXYDerivativeFilter alloc] init];
    
    //怀旧
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    
    //反色
    GPUImageColorInvertFilter *invertFilter = [[GPUImageColorInvertFilter alloc] init];
    
    //饱和度
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    
    //美颜
    GPUImageBeautifyFilter *beautyFielter = [[GPUImageBeautifyFilter alloc] init];
    
    //初始化GPUImageView
    self.myGPUImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    //初始设置为哈哈镜效果
    [self.myCamera addTarget:beautyFielter];
    [beautyFielter addTarget:self.myGPUImageView];
    self.myFilter = beautyFielter;
    [self.view addSubview:self.myGPUImageView];
    [self.myCamera startCameraCapture];

    [self.myCamera removeAllTargets];
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.myCamera addTarget:beautifyFilter];
    [beautifyFilter addTarget:self.myFilter];
    
    
    
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
    PhotoViewController * photo = [[PhotoViewController alloc]init];
    [self presentViewController:photo animated:NO completion:^{
        
    }];
}

-(void)ButProtionClick
{
    if (Protion == YES) {
        self.myCamera.captureSessionPreset = AVCaptureSessionPreset640x480;
        Protion = NO;
    }else
    {
       self.myCamera.captureSessionPreset = AVCaptureSessionPreset1280x720;
        Protion = YES;
    }
}



////确定
//-(void)ButSureClickSure
//{
//    //定格一张图片 保存到相册
//    [self.myCamera capturePhotoAsPNGProcessedUpToFilter:self.myFilter withCompletionHandler:^(NSData *processedPNG, NSError *error) {
//
//        //拿到相册，需要引入Photo Kit
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            //写入图片到相册
//            UIImage * image = [UIImage imageWithData:processedPNG];
//            [self saveImageToPhotoAlbum:image];
//
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            NSLog(@"success = %d, error = %@", success, error);
//        }];
//    }];
//    if (OpenFlash == NO ) {
//        [self FlashOn];
//    }
//}





#pragma mark - 拍照
//拍照
- (void) shutterCamera
{
    
//    [self.myCamera stopCameraCapture];
    
    //定格一张图片 保存到相册
    [self.myCamera capturePhotoAsPNGProcessedUpToFilter:self.myFilter withCompletionHandler:^(NSData *processedPNG, NSError *error) {

        //拿到相册，需要引入Photo Kit
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            UIImage * image = [UIImage imageWithData:processedPNG];
            [self saveImageToPhotoAlbum:image];

        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
    }];
    if (OpenFlash == NO ) {
        [self FlashOn];
    }
}
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    PhotoViewController * photo = [[PhotoViewController alloc]init];
    photo.PhotoImage = savedImage;

    [self presentViewController:photo animated:NO completion:^{
//        [self.myGPUImageView removeFromSuperview];
        [self.myCamera startCameraCapture];
    }];
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
//取消
-(void)cancle{
    
//    [self.myGPUImageView removeFromSuperview];
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
