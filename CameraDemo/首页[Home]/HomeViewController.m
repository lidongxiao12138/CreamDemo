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
@interface HomeViewController ()
{
    NSArray *dicArr;
}
@property (strong, nonatomic)  UIImageView *imageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    


    // Do any additional setup after loading the view from its nib.
}






- (IBAction)ButCameraClick:(id)sender {
    CameraViewController * camera = [[CameraViewController alloc]init];
    
    [self presentViewController:camera animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:camera animated:YES];
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
