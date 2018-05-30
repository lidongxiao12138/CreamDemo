//
//  AorBViewController.m
//  CameraDemo
//
//  Created by edz on 2018/5/22.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "AorBViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FCDetectViewController.h"
#import "PhotoViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"
#import "SVProgressHUD.h"
#import <Photos/Photos.h>
#import "ZLDefine.h"
#import "FSKGPUImageBeautyFilter.h"
#import "PhotoLastViewController.h"
#define kScreenBounds   [UIScreen mainScreen].bounds

@interface AorBViewController ()<UINavigationControllerDelegate>
{
    BOOL OpenFlash;
}
@property (weak, nonatomic) IBOutlet UIButton *ButFlshOpen;//闪光灯
@property (weak, nonatomic) IBOutlet UIButton *ButQieHuan;//切换
@property (weak, nonatomic) IBOutlet UIButton *ButClose;//关闭
@property (weak, nonatomic) IBOutlet UIButton *ButTakePhoto;//拍照
@property (weak, nonatomic) IBOutlet UIButton *ButAlbum;//相册

@property (weak, nonatomic) IBOutlet UIView *ViewPhotoCream;//相机


@property(strong,nonatomic)GPUImageStillCamera *myCamera;
@property(strong,nonatomic)GPUImageView *myGPUImageView;
@property(strong,nonatomic)GPUImageFilter *myFilter;

@property(nonatomic,retain)AVCaptureSession * AVSession;

@end

@implementation AorBViewController
- (void)viewWillAppear:(BOOL)animated{
    OpenFlash = YES;
    [super viewWillAppear:animated];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customCamera];
    // Do any additional setup after loading the view from its nib.
}

- (void)customCamera{
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化相机，第一个参数表示相册的尺寸，第二个参数表示前后摄像头
    self.myCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    //竖屏方向
    self.myCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.myCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.myCamera.horizontallyMirrorRearFacingCamera = NO;
    
//    //精致美颜
    GPUImageFilter * fskImage = [[GPUImageFilter alloc]init];
    //初始化GPUImageView
    self.myGPUImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    //初始设置为哈哈镜效果
    [self.myCamera addTarget:fskImage];
    [fskImage addTarget:self.myGPUImageView];
    self.myFilter = fskImage;
    [self.ViewPhotoCream addSubview:self.myGPUImageView];
    [self.myCamera startCameraCapture];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//闪光灯
- (IBAction)ButFlshOpenClick:(id)sender {
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
//切换摄像头
- (IBAction)ButQieHuanClick:(id)sender {
    [self.myCamera rotateCamera];
}
//关闭返回
- (IBAction)ButCloseClick:(id)sender {
    [self.myCamera startCameraCapture];
    [self.navigationController popViewControllerAnimated:YES];
}

//拍照
- (IBAction)ButTakePhotoClick:(id)sender {
    [self.myCamera capturePhotoAsImageProcessedUpToFilter:self.myFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        //拿到相册，需要引入Photo Kit
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               //写入图片到相册
                               PhotoLastViewController * photo = [[PhotoLastViewController alloc]init];
                               photo.PhotoImage  = processedImage;
                               [self.myCamera startCameraCapture];
                               
                               [self.navigationController pushViewController:photo animated:YES];
                           });
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
        }];
    }];
    
}
//相册
- (IBAction)ButAlbumClick:(id)sender {
    ZLOnePhoto *one = [ZLOnePhoto shareInstance];
    [one presentPicker:PickerType_Photo photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
        if (isCancel == NO) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               PhotoLastViewController * photo = [[PhotoLastViewController alloc]init];
                               photo.PhotoImage = image;
                               [self.navigationController pushViewController:photo animated:YES];
                           });
        }
    }];
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
