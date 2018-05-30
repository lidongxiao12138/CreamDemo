//
//  HomeViewController.m
//  CameraDemo
//
//  Created by edz on 2018/4/26.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "HomeViewController.h"
#import "CameraViewController.h"
#import "ZLDefine.h"
#import "MBProgressHUD.h"
#import "UIImage+FCExtension.h"
#import "SVProgressHUD.h"
#import "DrawPolygonView.h"
#import "DrawRightView.h"
#import "UIImageView+Zoom.h"
#import "DZMPhotoBrowser.h"
#import "UIImage+ColorAtPixel.h"
#import "FCPPFaceDetect.h"
#import "DCTitleRolling.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

#import "ViewXian.h"
@interface HomeViewController ()<CDDRollingDelegate,UINavigationControllerDelegate,SDCycleScrollViewDelegate>
{
    NSArray *dicArr;
    UIView * view1;
    NSInteger CycleIndex;
}
@property (strong, nonatomic)  UIImageView *imageView;
/* 淘宝 */
@property (strong , nonatomic)DCTitleRolling *tbRollingView;

@property (nonatomic, strong)SDCycleScrollView * scrollView;

@property (nonatomic ,strong)ViewXian * viewXian;

@end

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated{

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
    //轮播图
    [self CreatViewCycle];
    
    [self setUpTBRolling];
    
    [self.view addSubview:self.viewXian];
    
    // 系统声音
//    1020  1025 1313  1308

//    AudioServicesPlaySystemSound(1050);
//    // 震动 只有iPhone才能震动而且还得在设置里开启震动才行,其他的如touch就没有震动功能
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    // Do any additional setup after loading the view from its nib.
    
    
//    [self.ButLeft addTarget:self action:@selector(ButLeftClick) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.ButRight addTarget:self action:@selector(ButRightClick) forControlEvents:UIControlEventTouchUpInside];
}

//-(void)ButLeftClick
//{
//
//
//    if (CycleIndex == 2) {
//        [self.scrollView makeScrollViewScrollToIndex:0];
//    }else
//    {
//        [self.scrollView makeScrollViewScrollToIndex:CycleIndex +1];
//    }
//
//}
//
//-(void)ButRightClick
//{
//
//    if (CycleIndex == 0) {
//        [self.scrollView makeScrollViewScrollToIndex:2];
//    }else
//    {
//        [self.scrollView makeScrollViewScrollToIndex:CycleIndex - 1];
//    }
//
//}
//

//创建画眉教程
-(void)CreatViewCycle
{
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.ViewCycle.frame.size.width * D_width, self.ViewCycle.frame.size.height* D_height)
                                                     delegate:self
                                             placeholderImage:[UIImage imageNamed:@""]];
    _scrollView.localizationImageNamesGroup = @[      @"homebanner1",
                                                      @"homebanner2",
                                                      @"homebanner3",
                                                      @"homebanner4",
                                                      @"homebanner5"
                                                      ];
    _scrollView.autoScroll = YES;
    _scrollView.delegate = self;
    _scrollView.infiniteLoop = YES;
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;// 翻页 右下角
    _scrollView.titleLabelBackgroundColor = [UIColor blackColor];// 图片对应的标题的 背景色。（因为没有设标题）
    ViewRadius(_scrollView, 5);
    ViewRadius(self.ViewCycle, 5);
    _scrollView.backgroundColor = [UIColor blackColor];
    [self.ViewCycle addSubview:_scrollView];
}

#pragma mark - <CDDRollingDelegate>
- (void)dc_RollingViewSelectWithActionAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%zd头条滚动条",index);
    [_scrollView makeScrollViewScrollToIndex:2];

}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"%li ndex === ",(long)index);
    CycleIndex = index;
}


#pragma mark - TB
- (void)setUpTBRolling
{
    _tbRollingView = [[DCTitleRolling alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) WithTitleData:^(CDDRollingGroupStyle *rollingGroupStyle, NSString *__autoreleasing *leftImage, NSArray *__autoreleasing *rolTitles, NSArray *__autoreleasing *rolTags, NSArray *__autoreleasing *rightImages, NSString *__autoreleasing *rightbuttonTitle, NSInteger *interval, float *rollingTime, NSInteger *titleFont, UIColor *__autoreleasing *titleColor, BOOL *isShowTagBorder) {
        
        *rollingTime = 0.2;
//        *rightImages = @[@"jshop_sign_layer_not",@"jshop_sign_layer_ok"];
        *rollingGroupStyle  = CDDRollingTwoGroup;
//        *rolTags = @[@[@"热热",@"爆爆",@"红红"],@[@"冷知识",@"小常识",@"最新"]];
        *rolTitles = @[@[@"匿名用户 询问了画眉教程",@"匿名用户 使用了女生眉形并发布给了朋友",@"还在等什么，赶紧抢购"],@[@"匿名用户 询问了画眉教程",@"匿名用户 使用了女生眉形并发布给了朋友",@"还在等什么，赶紧抢购"]];
//        *leftImage = @"topTitle";
        *interval = 4.0;
        *titleFont = 14;
        *titleColor = [UIColor whiteColor];
        *isShowTagBorder = YES; //是否展示tag边框
        
    }];
    _tbRollingView.delegate = self;
    [_tbRollingView dc_beginRolling];
    _tbRollingView.backgroundColor = [UIColor blackColor];
    [self.ViewCDDTit addSubview:_tbRollingView];
}

- (IBAction)ButGoBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)ButCameraClick:(UIButton *)sender {
    CameraViewController * camera = [[CameraViewController alloc]init];
    if (sender.tag == 0) {
        InforModel * infor = [InforModel new];
        infor.nick_name = @"man";
        [[LoginDataModel sharedManager]saveLoginMemberData:infor];

    }else
    {
        InforModel * infor = [InforModel new];
        infor.nick_name = @"woman";
        [[LoginDataModel sharedManager]saveLoginMemberData:infor];
    }
    
    
    [self presentViewController:camera animated:YES completion:^{
        
    }];
}


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
