//
//  PhotoViewController.m
//  CameraDemo
//
//  Created by edz on 2018/4/27.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "PhotoViewController.h"
#import "ZLDefine.h"
#import "MBProgressHUD.h"
#import "UIImage+FCExtension.h"
#import "SVProgressHUD.h"
#import "DrawPolygonView.h"
#import "DrawRightView.h"
#import "UIImageView+Zoom.h"
#import "DZMPhotoBrowser.h"
#import "UIImage+ColorAtPixel.h"
#import "FXBlurView.h"
#import "GPUImageBeautifyFilter.h"
#import "BorwCollectionViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
@interface PhotoViewController ()<UIScrollViewDelegate,DZMPhotoBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,UIGestureRecognizerDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    NSString * templateID;
    NSArray * BrowsArray;
    NSString * SizeStr;
    NSString * ColorBrow;
    NSString * Density;
    UIImage * Brow1Image;
    UIImage * Brow2Image;
    UIImage * Brow3Image;
    UIImage * Brow4Image;
    NSString * ColorStr;
    
    NSString * urlStr;
    
    
    NSIndexPath * IndexTab;

    NSString * StrSex;
    
    CGFloat ViewHight1;
    CGFloat ViewHight2;
    CGFloat ViewHight3;
    CGFloat ViewHight4;
    
    CGFloat testLabelRotation; //label的旋转角度
    
    BOOL OpenGrid;//打开网格
    
    UIPanGestureRecognizer *pan;
    UIPanGestureRecognizer *pan1;
    UIPanGestureRecognizer *pan2;
    UIPanGestureRecognizer *pan3;
    UIPanGestureRecognizer *pan4;
    UIPanGestureRecognizer *pan5;
    UIPanGestureRecognizer *panImage;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    UIRotationGestureRecognizer *rotationGR;
    BOOL RotOpen;//打开旋转
    
    BOOL LockOpen;//锁

}
@property (weak, nonatomic) IBOutlet UIImageView *ImgPhoto;
@property (weak, nonatomic) IBOutlet UIButton *ButBack;

@property (strong , nonatomic) NSDictionary *bodyInfo;

@property (weak, nonatomic) IBOutlet UIButton *ButBorw1;
@property (weak, nonatomic) IBOutlet UIButton *ButBorw2;
@property (weak, nonatomic) IBOutlet UIButton *ButBorw3;

@property (nonatomic, strong) UIImageView * line;
@property (weak, nonatomic) IBOutlet UIView *ViewCollectBrow;

//创建collectionView
@property (nonatomic, strong)UICollectionView * BrowCollection;

@property (nonatomic, strong)SDCycleScrollView * scrollView;
@end

@implementation PhotoViewController

//网络请求

-(void)requsetUpImage
{
//    [self handleImage:self.ImgPhoto.image];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * url = k_BASE_URL(kUploadImg);
    params[@"sex"] = StrSex;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [[LDXNetworking sharedInstance]UpLoadWithPOST:url parameters:params image:self.ImgPhoto.image imageName:@"upfile" fileName:@"no uuid" progress:^(NSProgress * _Nullable progress) {
            //返回主线程 拿到数据
            [XcwHUD showWithStatus:@"正在识别面部......"];
            
            NSLog(@"progress === %@",progress);
        } success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject === %@",responseObject);
            NSLog(@"%@",responseObject[@"sessionID"]);
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               //返回主线程 拿到数据
                               [self requsetChange];
                           });
            
        
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error === %@",error);
            [SVProgressHUD showErrorWithStatus:@"没有检测到人脸"];
            [SVProgressHUD dismissWithDelay:2];
            
            [self dismissViewControllerAnimated:YES completion:^{
            }];            
            
        }];
        
    });
}


-(void)requsetChange
{
    
    [SVProgressHUD show];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
        NSString * url = k_BASE_URL(kchangeTemplate);
        
        params[@"density"] = Density;
        params[@"color"] = ColorBrow;
        params[@"browSize"] = SizeStr;
        params[@"templateID"] = templateID;
        NSLog(@"params === %@",params);
        
        [[LDXNetworking sharedInstance]POST:url parameters:params success:^(id  _Nonnull responseObject) {
            NSLog(@"responseObject === %@",responseObject);
            //返回主线程 拿到数据
            dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
            urlStr = [NSString stringWithFormat:@"%@",responseObject[@"resultURL"]];
            self.SliderColor.value = [Density floatValue];
            dispatch_sync(queue, ^{
                
                if ([[NSString stringWithFormat:@"%@",responseObject[@"scoreAfter"]]isEqualToString:@"<null>"]) {
                    [SVProgressHUD showErrorWithStatus:@"抱歉，暂无该眉形"];
                    [SVProgressHUD dismissWithDelay:2];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
//                    [SVProgressHUD showWithStatus:@"抱歉，暂无该眉形"];
//
//                    [SVProgressHUD dismissWithDelay:2];
                }else
                {
                    self.ImgPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:k_BASE_URL([urlStr substringFromIndex:1])]]];
                    
                    CGFloat sore = [responseObject[@"scoreAfter"] floatValue] * 100;
                    self.LabColor.text = [NSString stringWithFormat:@"%.0f分",sore];
                    
                    AudioServicesPlaySystemSound(1308);
                    // 震动 只有iPhone才能震动而且还得在设置里开启震动才行,其他的如touch就没有震动功能
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    
                    [XcwHUD hide];
                }
            
                CGFloat fixelW = CGImageGetWidth(self.ImgPhoto.image.CGImage);
                CGFloat fixelH = CGImageGetHeight(self.ImgPhoto.image.CGImage);
                
                NSLog(@"size.height ==== %f",fixelW);
                NSLog(@"size.width ==== %f",fixelH);
            });
    
            
           
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [XcwHUD hide];
        }];
    
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
   
    ViewHight1 = ViewHight2 = 70;
    ViewHight3 = ViewHight4 = 70;

    [self setUI];
    
    [self CreatXian];
    
    [self GetSex];
    
    [self CreatViewCycle];

    [self.ImgPhoto setUserInteractionEnabled:YES];

    if (self.PhotoImage != NULL) {
        self.ImgPhoto.image = self.PhotoImage;
        [self requsetUpImage];
    }
    
   
   // Do any additional setup after loading the view from its nib.
}

#pragma mark pan   图片平移手势事件
-(void)panImage:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:self.ImgPhoto];
   
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)CreatXian
{
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.ViewXian1 addGestureRecognizer:pan];

    pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView1:)];
    [self.ViewXian2 addGestureRecognizer:pan1];

    pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView2:)];
    [self.ViewXian3 addGestureRecognizer:pan2];
    
    pan3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView3:)];
    [self.ViewXian4 addGestureRecognizer:pan3];
    
    pan4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView4:)];
    [self.ViewXian5 addGestureRecognizer:pan4];
    
    pan5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView5:)];
    [self.ViewXian6 addGestureRecognizer:pan5];
    
    //让图片平移的手势
    panImage = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    [self.ImgPhoto addGestureRecognizer:panImage];
    
    // 缩放手势
    pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.ImgPhoto addGestureRecognizer:pinchGestureRecognizer];
    

}
#pragma mark pan   平移手势事件
-(void)panView:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:self.ViewXian1];
    self.ViewXian1.frame = CGRectMake(0, self.ViewXian1.frame.origin.y, self.ImgPhoto.frame.size.width, 20);
    self.ViewXian2.frame = CGRectMake(0,
                                      self.ViewXian5.frame.origin.y + 70 -(self.ViewXian1.frame.origin.y - (self.ViewXian5.frame.origin.y - 70)),
                                      self.ImgPhoto.frame.size.width,
                                      20);
    
    ViewHight1 = self.ViewXian5.frame.origin.y - self.ViewXian1.frame.origin.y;
    ViewHight2 = self.ViewXian2.frame.origin.y - self.ViewXian5.frame.origin.y;

    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView1:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:self.ViewXian2];
    self.ViewXian2.frame = CGRectMake(0, self.ViewXian2.frame.origin.y, self.ImgPhoto.frame.size.width, 20);
    self.ViewXian1.frame = CGRectMake(0,
                                      self.ViewXian5.frame.origin.y + 70 -(self.ViewXian2.frame.origin.y - (self.ViewXian5.frame.origin.y - 70)),
                                      self.ImgPhoto.frame.size.width,
                                      20);
    
    ViewHight1 = self.ViewXian5.frame.origin.y - self.ViewXian1.frame.origin.y;
    ViewHight2 = self.ViewXian2.frame.origin.y - self.ViewXian5.frame.origin.y;
    
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView2:(UIPanGestureRecognizer *)sender{

    CGPoint point = [sender translationInView:self.ViewXian3];
    self.ViewXian3.frame = CGRectMake(self.ViewXian3.frame.origin.x, 0, 20, self.ImgPhoto.frame.size.height);
    
    self.ViewXian4.frame = CGRectMake(self.ViewXian6.frame.origin.x + 70 -  (self.ViewXian3.frame.origin.x - (self.ViewXian6.frame.origin.x - 70)), 0, 20, self.ImgPhoto.frame.size.height);
    
    ViewHight3 = self.ViewXian6.frame.origin.x - self.ViewXian3.frame.origin.x;
    ViewHight4 = self.ViewXian4.frame.origin.x - self.ViewXian6.frame.origin.x;
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView3:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self.ViewXian4];
    self.ViewXian4.frame = CGRectMake(self.ViewXian4.frame.origin.x, 0, 20, self.ImgPhoto.frame.size.height);

    self.ViewXian3.frame = CGRectMake(self.ViewXian6.frame.origin.x + 70 -  (self.ViewXian4.frame.origin.x - (self.ViewXian6.frame.origin.x - 70)), 0, 20, self.ImgPhoto.frame.size.height);
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    ViewHight3 = self.ViewXian6.frame.origin.x - self.ViewXian3.frame.origin.x;
    ViewHight4 = self.ViewXian4.frame.origin.x - self.ViewXian6.frame.origin.x;
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView4:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self.ViewXian5];
     self.ViewXian5.frame = CGRectMake(0, self.ViewXian5.frame.origin.y, self.ImgPhoto.frame.size.width, 20);
    self.ViewXian1.frame = CGRectMake(0, self.ViewXian5.frame.origin.y - ViewHight1, self.ImgPhoto.frame.size.width, 20);

    self.ViewXian2.frame = CGRectMake(0, self.ViewXian5.frame.origin.y + ViewHight2, self.ImgPhoto.frame.size.width, 20);
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView5:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self.ViewXian6];
    self.ViewXian6.frame = CGRectMake(self.ViewXian6.frame.origin.x, 0, 20, self.ImgPhoto.frame.size.height);
    
    
    self.ViewXian3.frame = CGRectMake(self.ViewXian6.frame.origin.x - ViewHight3, 0, 20, self.ImgPhoto.frame.size.height);
    
    self.ViewXian4.frame = CGRectMake(self.ViewXian6.frame.origin.x + ViewHight4, 0, 20, self.ImgPhoto.frame.size.height);
    
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

//创建画眉教程
-(void)CreatViewCycle
{
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.ViewCycle.frame
                                                     delegate:self
                                             placeholderImage:[UIImage imageNamed:@""]];
    _scrollView.localizationImageNamesGroup = @[      @"Scr1",
                                                @"Scr2",
                                                @"Scr3",
                                                @"Scr4"];
    _scrollView.autoScroll = NO;
    _scrollView.infiniteLoop = YES;
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;// 翻页 右下角
    _scrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    [self.ViewCycle addSubview:_scrollView];
}

//接收性别
-(void)GetSex
{
    InforModel * loginMo = [[InforModel alloc]init];
    loginMo= [LoginDataModel sharedManager].inforModel;
    StrSex = loginMo.nick_name;
    NSLog(@"loginMo.nick_name ==== %@",loginMo.nick_name);
    if ([StrSex isEqualToString:@"woman"]) {
        BrowsArray = [NSArray arrayWithObjects:@"Brow1",@"Brow2",@"Brow3",@"Brow4", nil];
    }else
    {
        BrowsArray = [NSArray arrayWithObjects:@"manBrow1",@"manBrow2",@"manBrow3", nil];
    }
    if ([StrSex isEqualToString:@"woman"]) {
        templateID = @"B004";
    }else
    {
        templateID = @"NW001";
    }
    
    SizeStr = @"M";
    Density = @"0.61";
    ColorBrow = @"black";
    ColorStr = @"2";


    
}


//创建视图
-(void)setUI
{
    [self.ButBorwColor addTarget:self action:@selector(ButBorwColorClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButFine.layer setMasksToBounds:YES];
    [self.ButFine.layer setCornerRadius:15];
    [self.ButFine addTarget:self action:@selector(ButFineClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButCenter.layer setMasksToBounds:YES];
    [self.ButCenter.layer setCornerRadius:15];
    [self.ButCenter addTarget:self action:@selector(ButCenterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButCoarse.layer setMasksToBounds:YES];
    [self.ButCoarse.layer setCornerRadius:15];
    [self.ButCoarse addTarget:self action:@selector(ButCoarseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.ButTorial addTarget:self action:@selector(ButTorialClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.ViewSoure, 10);
    ViewRadius(self.ViewCorlor, 10);
    [self.ButShowOrg addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
    [self.ButShowOrg addTarget:self action:@selector(buttonTouchedUpOutside:) forControlEvents: UIControlEventTouchUpInside];
    [self.ButBack addTarget:self action:@selector(ButBackClick) forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(self.ButBack, 15);
    [self.view addSubview:self.ButBack];
    
    ViewBorderRadius(self.ButColor1, 3, 1, kRGB(115, 100, 92));
    ViewBorderRadius(self.ButColor2, 3, 1, kRGB(151, 134, 108));

    //网格
    [self.ButGrid addTarget:self action:@selector(ButGridClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ViewCollectBrow addSubview:self.BrowCollection];
   
    //是否显示眉形
    [self.ButSeletedBrow addTarget:self action:@selector(ButSeletedBrowClick:) forControlEvents:UIControlEventTouchUpInside];
    //眉形粗细
    [self.ButBrowSize addTarget:self action:@selector(ButBrowSizeClick:) forControlEvents:UIControlEventTouchUpInside];
    //返回选择眉形
    [self.ButBackBrow addTarget:self action:@selector(ButBackBrowClick:) forControlEvents:UIControlEventTouchUpInside];

    //颜色1
    [self.ButColor1 addTarget:self action:@selector(ButColor1Click:) forControlEvents:UIControlEventTouchUpInside];
    //颜色2
    [self.ButColor2 addTarget:self action:@selector(ButColor2Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.SliderColor addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.SliderColor setThumbImage:[UIImage imageNamed:@"Silder"] forState:UIControlStateNormal];
}
//当旋转时执行此方法
- (void)rotationAct:(UIRotationGestureRecognizer *)sender{
    [self.ViewImageRot bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
    //根据传回的旋转角度修改lable的当前角度
    self.ViewImageRot.transform = CGAffineTransformMakeRotation(testLabelRotation+sender.rotation);
    
    //当旋转结束后更新lable的角度，以备下次使用
    if (sender.state == UIGestureRecognizerStateEnded) {
        testLabelRotation += sender.rotation;
    }
    
    
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
//选择颜色1
-(void)ButColor1Click:(UIButton *)sender
{
    ColorBrow = @"brown1";
    ViewBorderRadius(self.ButColor1, 3, 1, [UIColor whiteColor]);
    ViewBorderRadius(self.ButColor2, 3, 1, kRGB(151, 134, 108));
    [self requsetChange];
}
//选择颜色2
-(void)ButColor2Click:(UIButton *)sender
{
    ColorBrow = @"black";
    ViewBorderRadius(self.ButColor2, 3, 1, [UIColor whiteColor]);
    ViewBorderRadius(self.ButColor1, 3, 1, kRGB(151, 134, 108));
    [self requsetChange];
}


-(void)ButBackClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.ImgPhoto.image = nil;
        [XcwHUD hide];
    }];
}

-(void)buttonTouchedDown:(UIButton *)sender
{
    self.ImgPhoto.image = self.PhotoImage;
}

-(void)buttonTouchedUpOutside:(UIButton *)sender
{
    self.ImgPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:k_BASE_URL([urlStr substringFromIndex:1])]]];
}


//细眉毛
-(void)ButFineClick
{
    SizeStr = @"S";

    [self.ButFine setBackgroundColor:KNavigationBgColor];
    [self.ButCenter setBackgroundColor:RGBA(85, 85, 85, 1)];
    [self.ButCoarse setBackgroundColor:RGBA(85, 85, 85, 1)];
    if ([templateID isEqualToString:@"P003"]) {
        
    }else
    {
        [self requsetChange];
    }
}

//中眉毛
-(void)ButCenterClick
{
    SizeStr = @"M";
    [self.ButCenter setBackgroundColor:KNavigationBgColor];
    [self.ButFine setBackgroundColor:RGBA(85, 85, 85, 1)];
    [self.ButCoarse setBackgroundColor:RGBA(85, 85, 85, 1)];
    [self requsetChange];

}

//粗眉毛
-(void)ButCoarseClick
{
    SizeStr = @"L";
    [self.ButCoarse setBackgroundColor:KNavigationBgColor];
    [self.ButFine setBackgroundColor:RGBA(85, 85, 85, 1)];
    [self.ButCenter setBackgroundColor:RGBA(85, 85, 85, 1)];
    if ([templateID isEqualToString:@"W001"]) {
        
    }else
    {
        [self requsetChange];
    }
}
//显示眉形粗细
-(void)ButBrowSizeClick:(UIButton *)sender
{
    [self.ButBrowSize setTitleColor:KNavigationBgColor forState:UIControlStateNormal];
    [self.ButBorwColor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ButTorial setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    if ([StrSex isEqualToString:@"woman"]) {
        BrowsArray = [NSArray arrayWithObjects:@"Brow1",@"Brow2",@"Brow3",@"Brow4", nil];
    }else
    {
        BrowsArray = [NSArray arrayWithObjects:@"manBrow1",@"manBrow2",@"manBrow3", nil];
    }
    self.ViewSlider.hidden = YES;
    ColorStr = @"2";
    [self.BrowCollection reloadData];
}

//变换眉色
-(void)ButBorwColorClick
{
    [self.ButBorwColor setTitleColor:KNavigationBgColor forState:UIControlStateNormal];
    [self.ButBrowSize setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ButTorial setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ViewSlider.hidden = NO;
}

//是否显示眉形
-(void)ButSeletedBrowClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        self.ViewBorwScore.hidden = YES;
        sender.selected = YES;
    }else
    {
        self.ViewBorwScore.hidden = NO;
        sender.selected = NO;
    }
}
//返回
-(void)ButBackBrowClick:(UIButton *)sender
{
    self.ViewCycle.hidden = YES;
    self.ViewBackBrow.hidden = YES;
}


-(void)ButTorialClick:(UIButton *)sender
{
    [self.ButTorial setTitleColor:KNavigationBgColor forState:UIControlStateNormal];
    [self.ButBorwColor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ButBrowSize setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.ViewCycle.hidden = NO;
    self.ViewBackBrow.hidden = NO;
}






- (void)handleImage:(UIImage *)image{
    //清除人脸框
    [self.ImgPhoto.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //检测人脸
    FCPPFaceDetect *faceDetect = [[FCPPFaceDetect alloc] initWithImage:image];
    self.ImgPhoto.image = faceDetect.image;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    //需要获取的属性
    NSArray *att = @[@"eyestatus"];
    [faceDetect detectFaceWithReturnLandmark:YES attributes:att completion:^(id info, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (info) {
            NSArray *array = info[@"faces"];
            if (array.count) {
//                UIImage *image = faceDetect.image;
//
//                //绘制关键点和矩形框
//                [weakSelf handleImage:image withInfo:array];
                
//                [SVProgressHUD showSuccessWithStatus:@"检测到人脸"];

            }else{

 
            }
        }else{

        }
    }];
    
}

- (void)handleImage:(UIImage *)image withInfo:(NSArray *)array{
    
    CGFloat scaleH = self.ImgPhoto.bounds.size.width / image.size.width;
    CGFloat scaleV = self.ImgPhoto.bounds.size.height / image.size.height;
    CGFloat scale = scaleH < scaleV ? scaleH : scaleV;
    CGFloat offsetX = image.size.width*(scaleH - scale)*0.5;
    CGFloat offsetY = image.size.height*(scaleV - scale)*0.5;
   
    
    NSLog(@"%@",array[0][@"landmark"][@"left_eyebrow_upper_middle"][@"x"]);
    NSLog(@"%@",array[0][@"landmark"][@"left_eyebrow_upper_middle"][@"y"]);
    
    CGFloat colorFloatx = [array[array.count - 1][@"landmark"][@"left_eyebrow_upper_middle"][@"x"] floatValue];
    CGFloat colorFloaty = [array[array.count - 1][@"landmark"][@"left_eyebrow_upper_middle"][@"y"] floatValue];
    
    CGFloat RcolorFloatx = [array[array.count - 1][@"landmark"][@"right_eyebrow_upper_middle"][@"x"] floatValue];
    CGFloat RcolorFloaty = [array[array.count - 1][@"landmark"][@"right_eyebrow_upper_middle"][@"y"] floatValue];
    

    //绘制矩形框
    for (NSDictionary *dic in array) {
        NSDictionary *rect = dic[@"face_rectangle"];
        CGFloat angle = [dic[@"attributes"][@"headpose"][@"roll_angle"] floatValue];
        
        CGFloat x = [rect[@"left"] floatValue];
        CGFloat y = [rect[@"top"] floatValue];
        CGFloat w = [rect[@"width"] floatValue];
        CGFloat h = [rect[@"height"] floatValue];
        
        UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(x*scale+offsetX, y*scale+offsetY, w*scale, h*scale)];
        rectView.transform = CGAffineTransformMakeRotation(angle/360.0 *2*M_PI);
        rectView.layer.borderColor = [UIColor clearColor].CGColor;
        rectView.layer.borderWidth = 1;
        
        [self.ImgPhoto addSubview:rectView];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x*scale+offsetX, y*scale+offsetY, w*scale, h*scale)];
        imageView.image = [UIImage imageNamed:@"pick_bg"];
//        [self.ImgPhoto addSubview:imageView];
        
        upOrdown = NO;
        num =0;
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(x*scale+offsetX, y*scale+offsetY, w*scale, 2)];
        _line.image = [UIImage imageNamed:@"line.png"];
//        [self.ImgPhoto addSubview:_line];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
- (IBAction)ButBorwClick1:(id)sender {

    
}
- (IBAction)ButBorwClick2:(id)sender {
  
    
}
- (IBAction)ButBorwClick3:(id)sender {
   
    
}
- (IBAction)ButSaveClick:(id)sender {
//    [self snapshotScreenInView:self.ImgPhoto];
    if (OpenGrid == YES) {
        [self captureView:self.ViewCarp];
    }
    UIImageWriteToSavedPhotosAlbum(self.ImgPhoto.image, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}


- (void)snapshotScreenInView:(UIView *)contentView {
    CGSize size = contentView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = contentView.frame;
    //  自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates: 它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
}


-(UICollectionView * )BrowCollection
{
    if (!_BrowCollection) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _BrowCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.ViewCollectBrow.frame.size.width * D_width, self.ViewCollectBrow.frame.size.height) collectionViewLayout:layout];
        _BrowCollection.backgroundColor = [UIColor blackColor];
        _BrowCollection.delegate = self;
        _BrowCollection.dataSource = self;
    }
    return _BrowCollection;
}
#pragma mark -UICollectionView 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //cell个数,根据model,点击添加,增加一条数据
    // 添加cell和普通cell的大小都一样,只是显示的内容不一样.  初始化,只放置一个,当增加了数据,就把这个往后排.  collectionView具有自动的往前/后移动的效果.
    return BrowsArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //从重用队列获取
    //这里,不定时崩溃  indexPath.item 貌似不能为0
    UINib * nib = [UINib nibWithNibName:@"BorwCollectionViewCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"reuseId"];
    BorwCollectionViewCell * BrowCell = [[BorwCollectionViewCell alloc]init];
    [BrowCell.layer setCornerRadius:BrowCell.frame.size.width/2];
    [BrowCell.layer setMasksToBounds:YES];
    BrowCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseId" forIndexPath:indexPath];
    if ([ColorStr isEqualToString:@"1"]) {

    }else
    {
        BrowCell.ImageBrow.backgroundColor = [UIColor clearColor];
        [BrowCell.ImageBrow setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",BrowsArray[indexPath.row]]]];
    }
    
    return BrowCell;
}

//设置每个Cell 的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(100, 70);
}

//设置Cell 之间的间距 （上，左，下，右）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2.5, 5, 2.5, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    IndexTab = indexPath;
    if ([ColorStr isEqualToString:@"2"]) {
        
        if ([StrSex isEqualToString:@"woman"]) {
         
            if (indexPath.row == 0)
            {
                self.LabSore.text = @"眉形一";
                Density = @"0.61";
                ColorBrow = @"black";
                templateID = @"B004";
                [self requsetChange];
                
            }else if (indexPath.row == 1)
            {
                self.LabSore.text = @"眉形二";
                Density = @"0.61";
                ColorBrow = @"black";
                templateID = @"T002";
                [self requsetChange];
                
            }else if (indexPath.row == 2)
            {
                self.LabSore.text = @"眉形三";
                Density = @"1.00";
                ColorBrow = @"brown1";
                templateID = @"T004";
                [self requsetChange];
                
                
            }else if (indexPath.row == 3)
            {
                self.LabSore.text = @"眉形四";
                ColorBrow = @"brown1";
                Density = @"1.00";
                templateID = @"W001";
                [self requsetChange];
                
                
            }
            
        }else
        {
            if (indexPath.row == 0)
            {
                self.LabSore.text = @"眉形一";
                Density = @"0.61";
                ColorBrow = @"black";
                templateID = @"NW001";
                [self requsetChange];
                
            }else if (indexPath.row == 1)
            {
                self.LabSore.text = @"眉形二";
                Density = @"0.61";
                ColorBrow = @"black";
                templateID = @"NJ001";
                [self requsetChange];
                
            }else if (indexPath.row == 2)
            {
                self.LabSore.text = @"眉形三";
                Density = @"1.00";
                ColorBrow = @"brown1";
                templateID = @"NP001";
                [self requsetChange];
            }
        }
        
    }
    
}

-(void)sliderValueChanged:(UISlider *)slider
{
    NSLog(@"slider value%2f",slider.value);
    NSString * str = [NSString stringWithFormat:@"%0.2f",slider.value];
    NSLog(@"%@",str);
    
    Density = [NSString stringWithFormat:@"%0.2f",slider.value];
   
    [self requsetChange];
}

//允许打开手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

//将View变成图片
-(UIImage*) captureView:(UIView *)theView {
    CGRect rect = theView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    return img;
}

-(void)ButGridClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        //打开网格线
        
        self.ViewXian1.hidden = NO;
        self.ViewXian2.hidden = NO;
        self.ViewXian3.hidden = NO;
        self.ViewXian4.hidden = NO;
        self.ViewXian5.hidden = NO;
        self.ViewXian6.hidden = NO;
        sender.selected = YES;
        self.ButLock.hidden = NO;
        OpenGrid = sender.selected;
        
    }else
    {
        //关闭网格线
        self.ViewXian1.hidden = YES;
        self.ViewXian2.hidden = YES;
        self.ViewXian3.hidden = YES;
        self.ViewXian4.hidden = YES;
        self.ViewXian5.hidden = YES;
        self.ViewXian6.hidden = YES;
        OpenGrid = sender.selected;
        self.ButLock.hidden = YES;
        sender.selected = NO;
    }
}

- (IBAction)ButLockClick:(UIButton *)sender {
    if (sender.selected == NO) {
        
        
        if ( RotOpen == YES) {
            [XcwHUD showErrorWithMessage:@"网格线已锁定"];
        
            [self.ButLock setImage:[UIImage imageNamed:@"LockClose"] forState:UIControlStateNormal];
            
        }else
        {
            [XcwHUD showErrorWithMessage:@"网格线已锁定"];
            
            [self.ViewXian5 removeGestureRecognizer:pan4];
            [self.ViewXian6 removeGestureRecognizer:pan5];
            
            [self.ImgPhoto removeGestureRecognizer:panImage];//平移
            [self.ImgPhoto removeGestureRecognizer:pinchGestureRecognizer];//缩放
            [self.ImgPhoto removeGestureRecognizer:rotationGR];//旋转
            
            [self.ButLock setImage:[UIImage imageNamed:@"LockClose"] forState:UIControlStateNormal];
        }
        LockOpen = YES;

        sender.selected = YES;

    }else
    {
        if ( RotOpen == YES) {
            [XcwHUD showSuccessWithMessage:@"网格线已打开，关闭旋转可放大，移动"];
            //创建UIRotationGestureRecognizer 用来实现旋转手势
            rotationGR = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAct:)];
            [self.view addGestureRecognizer:rotationGR];
            //            sender.selected = NO;
            [self.ButLock setImage:[UIImage imageNamed:@"LockOpen"] forState:UIControlStateNormal];
            
        }else{
            [XcwHUD showSuccessWithMessage:@"网格线已打开"];
            [self.ButLock setImage:[UIImage imageNamed:@"LockOpen"] forState:UIControlStateNormal];
            [self CreatXian];
        }
        
        LockOpen = NO;

        sender.selected = NO;

    }
}

- (IBAction)ButRotClick:(UIButton *)sender {
    
    if (sender.selected == NO) {
        [XcwHUD showSuccessWithMessage:@"旋转已打开"];
        //添加旋转手势
        //创建UIRotationGestureRecognizer 用来实现旋转手势
        rotationGR = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAct:)];
        [self.view addGestureRecognizer:rotationGR];

    
        
        //全部禁掉
        [self.ViewXian1 removeGestureRecognizer:pan];
        [self.ViewXian2 removeGestureRecognizer:pan1];
        [self.ViewXian3 removeGestureRecognizer:pan2];
        [self.ViewXian4 removeGestureRecognizer:pan3];
        [self.ViewXian5 removeGestureRecognizer:pan4];
        [self.ViewXian6 removeGestureRecognizer:pan5];
        
        [self.ImgPhoto removeGestureRecognizer:panImage];//平移
        [self.ImgPhoto removeGestureRecognizer:pinchGestureRecognizer];//缩放

        self.ImageRot1.hidden = NO;
        self.ImageRot2.hidden = NO;
        sender.selected = YES;
        RotOpen = YES;

        [self.ButRot setImage:[UIImage imageNamed:@"RotOpen"] forState:UIControlStateNormal];
    }else
    {
        [XcwHUD showErrorWithMessage:@"旋转已关闭"];
        self.ImageRot1.hidden = YES;
        self.ImageRot2.hidden = YES;
        sender.selected = NO;
        [self.ImgPhoto removeGestureRecognizer:rotationGR];
        if (LockOpen == NO) {
            
            [self CreatXian];
            
        }else
        {
            pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
            [self.ViewXian1 addGestureRecognizer:pan];
            
            pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView1:)];
            [self.ViewXian2 addGestureRecognizer:pan1];
            
            pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView2:)];
            [self.ViewXian3 addGestureRecognizer:pan2];
            
            pan3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView3:)];
            [self.ViewXian4 addGestureRecognizer:pan3];
            
            pan4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView4:)];
            [self.ViewXian5 addGestureRecognizer:pan4];
        }
        [self.ButRot setImage:[UIImage imageNamed:@"RotColse"] forState:UIControlStateNormal];
        RotOpen = NO;
    }
    
    
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
