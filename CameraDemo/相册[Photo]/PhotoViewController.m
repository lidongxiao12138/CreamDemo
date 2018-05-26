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


@interface PhotoViewController ()<UIScrollViewDelegate,DZMPhotoBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    NSString * templateID;
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


@end

@implementation PhotoViewController

//网络请求

-(void)requsetUpImage
{
    [XcwHUD showSuccessWithMessage:@"正在识别面部......"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * url = k_BASE_URL(kUploadImg);
    params[@"sex"] = @"man";
    [[LDXNetworking sharedInstance]UpLoadWithPOST:url parameters:params image:self.ImgPhoto.image imageName:@"upfile" fileName:@"no uuid" progress:^(NSProgress * _Nullable progress) {
        NSLog(@"progress === %@",progress);
    } success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject === %@",responseObject);
        templateID = [NSString stringWithFormat:@"%@",responseObject[@"recommend"]];
        [self requsetChange];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error === %@",error);
        [XcwHUD hide];
    }];
}


-(void)requsetChange
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * url = k_BASE_URL(kchangeTemplate);
    params[@"templateID"] = templateID;
    params[@"browSize"] = @"L";
    params[@"density"] = @"0.61";
    params[@"color"] = @"black";
    [[LDXNetworking sharedInstance]POST:url parameters:params success:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject === %@",responseObject);
        NSString * urlStr = [NSString stringWithFormat:@"%@",responseObject[@"boutlineURL"]];
        [self.ImgPhoto sd_setImageWithURL:[NSURL URLWithString:k_BASE_URL([urlStr substringFromIndex:1])]];
        [XcwHUD hide];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [XcwHUD hide];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGImageRef cgref = [self.PhotoImage CGImage];

    NSLog(@"%@",cgref);
    if (cgref == NULL) {
        ZLOnePhoto *one = [ZLOnePhoto shareInstance];
        [one presentPicker:PickerType_Photo photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
            self.ImgPhoto.image = image;
            [self handleImage:image];
            [self requsetUpImage];
        }];
    }else
    {
        self.ImgPhoto.image = self.PhotoImage;
        [self requsetUpImage];
        [self handleImage:self.PhotoImage];
    }
    
    
    [self.ButBack addTarget:self action:@selector(ButBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ButBack];
    
    
    [self.ViewCollectBrow addSubview:self.BrowCollection];
    // Do any additional setup after loading the view from its nib.
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

-(void)ButBackClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.PhotoImage = nil;
    }];
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
                UIImage *image = faceDetect.image;
                
                //绘制关键点和矩形框
                [weakSelf handleImage:image withInfo:array];
                
                [SVProgressHUD showSuccessWithStatus:@"检测到人脸"];

            }else{

                [SVProgressHUD showErrorWithStatus:@"没有检测到人脸"];
                ZLOnePhoto *one = [ZLOnePhoto shareInstance];
                [one presentPicker:PickerType_Photo photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                    self.ImgPhoto.image = image;
                    [self handleImage:image];
                }];

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
- (IBAction)ButBorwClick1:(id)sender {

    
}
- (IBAction)ButBorwClick2:(id)sender {
  
    
}
- (IBAction)ButBorwClick3:(id)sender {
   
    
}
- (IBAction)ButSaveClick:(id)sender {
    [self snapshotScreenInView:self.ImgPhoto];
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
        _BrowCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.ViewCollectBrow.frame.size.width, self.ViewCollectBrow.frame.size.height) collectionViewLayout:layout];
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
    return 10;
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
    return BrowCell;
}

//设置每个Cell 的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

//设置Cell 之间的间距 （上，左，下，右）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2.5, 0, 2.5, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
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
