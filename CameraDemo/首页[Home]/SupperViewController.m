//
//  SupperViewController.m
//  CameraDemo
//
//  Created by edz on 2018/5/21.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "SupperViewController.h"
#import "HomeViewController.h"
#import "DCTitleRolling.h"
#import "AorBViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface SupperViewController ()<CDDRollingDelegate,SDCycleScrollViewDelegate,UINavigationControllerDelegate>
/* 淘宝 */
@property (strong , nonatomic)DCTitleRolling *tbRollingView;

@property (nonatomic, strong)SDCycleScrollView * scrollView;

@end

@implementation SupperViewController
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
    ViewRadius(self.ViewChoose, 5);
    //轮播图
    [self CreatViewCycle];
    //轮播文字
    [self setUpTBRolling];
    // Do any additional setup after loading the view from its nib.
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
    [self.ViewCycle addSubview:_tbRollingView];
}


#pragma mark - <CDDRollingDelegate>
- (void)dc_RollingViewSelectWithActionAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%zd头条滚动条",index);
}

//创建画眉教程
-(void)CreatViewCycle
{
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.ImageHeadView.frame.size.height)
                                                     delegate:self
                                             placeholderImage:[UIImage imageNamed:@""]];
    _scrollView.localizationImageNamesGroup = @[      @"SupperImage",
                                                      @"banner2",
                                                      @"banner3",
                                                      
                                                      ];
//    _scrollView.autoScroll = YES;
//    _scrollView.infiniteLoop = YES;
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;// 翻页 右下角
    _scrollView.titleLabelBackgroundColor = [UIColor blackColor];// 图片对应的标题的 背景色。（因为没有设标题）
    [self.ImageHeadView addSubview:_scrollView];
}

- (IBAction)ButDesignClick:(id)sender {
    HomeViewController * home = [[HomeViewController alloc]init];
    [self.navigationController pushViewController:home animated:YES];
}
- (IBAction)ButAorBClick:(id)sender {
    AorBViewController * AtoB = [[AorBViewController alloc]init];
    [self.navigationController pushViewController:AtoB animated:YES];
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
