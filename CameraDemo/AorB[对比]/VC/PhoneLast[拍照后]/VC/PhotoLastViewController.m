//
//  PhotoLastViewController.m
//  CameraDemo
//
//  Created by edz on 2018/5/22.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "PhotoLastViewController.h"

@interface PhotoLastViewController ()<UINavigationControllerDelegate>
{
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
@end

@implementation PhotoLastViewController
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
    // Do any additional setup after loading the view from its nib.
    ViewHight1 = ViewHight2 = ViewHight3 = ViewHight4 = 70;

    [self CreatXian];
    
    [self.ImagePhoto setUserInteractionEnabled:YES];

   
    

    if (self.PhotoImage != NULL) {
        self.ImagePhoto.image = self.PhotoImage;
        
        NSLog(@"self.ImgPhoto.frame === %f",self.ImagePhoto.frame.size.width);
        CGFloat fixelW = CGImageGetWidth(self.PhotoImage.CGImage);
        CGFloat fixelH = CGImageGetHeight(self.PhotoImage.CGImage);
        NSLog(@"self.PhotoImage === %f",fixelW);
        NSLog(@"fixelH === %f",fixelH);
        
    }
    
    

}
#pragma mark pan   图片平移手势事件
-(void)panImage:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:self.ImagePhoto];
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    // Figure out where the user is trying to drag the view.

    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    
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
    [self.ImagePhoto addGestureRecognizer:panImage];
    
    // 缩放手势
    pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    
    [self.ImagePhoto addGestureRecognizer:pinchGestureRecognizer];
    
}

#pragma mark pan   平移手势事件
-(void)panView:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:self.ViewXian1];
    self.ViewXian1.frame = CGRectMake(0, self.ViewXian1.frame.origin.y, self.ImagePhoto.frame.size.width, 20);
    self.ViewXian2.frame = CGRectMake(0,
                                      self.ViewXian5.frame.origin.y + 70 -(self.ViewXian1.frame.origin.y - (self.ViewXian5.frame.origin.y - 70)),
                                      self.ImagePhoto.frame.size.width,
                                      20);
    
    ViewHight1 = self.ViewXian5.frame.origin.y - self.ViewXian1.frame.origin.y;
    ViewHight2 = self.ViewXian2.frame.origin.y - self.ViewXian5.frame.origin.y;
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView1:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:self.ViewXian2];
    self.ViewXian2.frame = CGRectMake(0, self.ViewXian2.frame.origin.y, self.ImagePhoto.frame.size.width, 20);
    self.ViewXian1.frame = CGRectMake(0,
                                      self.ViewXian5.frame.origin.y + 70 -(self.ViewXian2.frame.origin.y - (self.ViewXian5.frame.origin.y - 70)),
                                      self.ImagePhoto.frame.size.width,
                                      20);
    
    ViewHight1 = self.ViewXian5.frame.origin.y - self.ViewXian1.frame.origin.y;
    ViewHight2 = self.ViewXian2.frame.origin.y - self.ViewXian5.frame.origin.y;
    
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView2:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:self.ViewXian3];
    self.ViewXian3.frame = CGRectMake(self.ViewXian3.frame.origin.x, 0, 20, self.ImagePhoto.frame.size.height);
    
    self.ViewXian4.frame = CGRectMake(self.ViewXian6.frame.origin.x + 70 -  (self.ViewXian3.frame.origin.x - (self.ViewXian6.frame.origin.x - 70)), 0, 20, self.ImagePhoto.frame.size.height);
    
    ViewHight3 = self.ViewXian6.frame.origin.x - self.ViewXian3.frame.origin.x;
    ViewHight4 = self.ViewXian4.frame.origin.x - self.ViewXian6.frame.origin.x;
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView3:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self.ViewXian4];
    self.ViewXian4.frame = CGRectMake(self.ViewXian4.frame.origin.x, 0, 20, self.ImagePhoto.frame.size.height);
    
    self.ViewXian3.frame = CGRectMake(self.ViewXian6.frame.origin.x + 70 -  (self.ViewXian4.frame.origin.x - (self.ViewXian6.frame.origin.x - 70)), 0, 20, self.ImagePhoto.frame.size.height);
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    ViewHight3 = self.ViewXian6.frame.origin.x - self.ViewXian3.frame.origin.x;
    ViewHight4 = self.ViewXian4.frame.origin.x - self.ViewXian6.frame.origin.x;
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView4:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self.ViewXian5];
    self.ViewXian5.frame = CGRectMake(0, self.ViewXian5.frame.origin.y, self.ImagePhoto.frame.size.width, 20);
    self.ViewXian1.frame = CGRectMake(0, self.ViewXian5.frame.origin.y - ViewHight1, self.ImagePhoto.frame.size.width, 20);
    
    self.ViewXian2.frame = CGRectMake(0, self.ViewXian5.frame.origin.y + ViewHight2, self.ImagePhoto.frame.size.width, 20);
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)panView5:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self.ViewXian6];
    self.ViewXian6.frame = CGRectMake(self.ViewXian6.frame.origin.x, 0, 20, self.ImagePhoto.frame.size.height);
    
    
    self.ViewXian3.frame = CGRectMake(self.ViewXian6.frame.origin.x - ViewHight3, 0, 20, self.ImagePhoto.frame.size.height);
    
    self.ViewXian4.frame = CGRectMake(self.ViewXian6.frame.origin.x + ViewHight4, 0, 20, self.ImagePhoto.frame.size.height);
    
    
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    //增量置为o
    [sender setTranslation:CGPointZero inView:sender.view];
}
- (IBAction)ButGoBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ButSaveClick:(id)sender {
    if (OpenGrid == YES) {
        [self captureView:self.ViewCaper];
    }
    UIImageWriteToSavedPhotosAlbum(self.ImagePhoto.image, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
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

- (IBAction)ButWangGeClick:(UIButton *)sender {
    
    if (sender.selected == NO) {
        
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

            [self.ViewXian5 removeGestureRecognizer:pan4];
            [self.ViewXian6 removeGestureRecognizer:pan5];
            [self.ImagePhoto removeGestureRecognizer:panImage];
            [self.ImagePhoto removeGestureRecognizer:pinchGestureRecognizer];
            [self.view removeGestureRecognizer:rotationGR];
            
            
            [self.ButLock setImage:[UIImage imageNamed:@"LockClose"] forState:UIControlStateNormal];
            [XcwHUD showErrorWithMessage:@"网格线已锁定"];
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
            [self.ButLock setImage:[UIImage imageNamed:@"LockOpen"] forState:UIControlStateNormal];
            [XcwHUD showSuccessWithMessage:@"网格线已打开"];
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
        
        [self.ImagePhoto removeGestureRecognizer:panImage];//平移
        [self.ImagePhoto removeGestureRecognizer:pinchGestureRecognizer];//缩放
        
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
        [self.view removeGestureRecognizer:rotationGR];
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
