//
//  PhotoViewController.h
//  CameraDemo
//
//  Created by edz on 2018/4/27.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCBaseViewController.h"
#import "FCPPSDK.h"
@interface PhotoViewController : UIViewController
@property (nonatomic, strong)UIImage * PhotoImage;
@property (weak, nonatomic) IBOutlet UIButton *ButBorwColor;//眉心

@property (weak, nonatomic) IBOutlet UIButton *ButBrowSize;//粗细

@property (weak, nonatomic) IBOutlet UIButton *ButFine;//细
@property (weak, nonatomic) IBOutlet UIButton *ButCenter;//中
@property (weak, nonatomic) IBOutlet UIButton *ButCoarse;//粗

@property (weak, nonatomic) IBOutlet UIView *ViewSoure;//颜色

@property (weak, nonatomic) IBOutlet UIView *ViewCorlor;//评分

@property (weak, nonatomic) IBOutlet UILabel *LabSore;

@property (weak, nonatomic) IBOutlet UILabel *LabColor;

@property (weak, nonatomic) IBOutlet UIImageView *ImagePalette;
@property (weak, nonatomic) IBOutlet UISlider *SliderColor;
@property (weak, nonatomic) IBOutlet UIView *ViewSlider;

@property (weak, nonatomic) IBOutlet UIButton *LabBorwTitle;
@property (weak, nonatomic) IBOutlet UIButton *ButBrowImage;

@property (weak, nonatomic) IBOutlet UIButton *ButShowOrg;

@property (weak, nonatomic) IBOutlet UIButton *ButTorial;//画眉

@property (weak, nonatomic) IBOutlet UIView *ViewCycle;//滚动
@property (weak, nonatomic) IBOutlet UIButton *ButGrid;//网格
/**
 选择是否显示眉形
 */
@property (weak, nonatomic) IBOutlet UIButton *ButSeletedBrow;
/**
  评分
 */
@property (weak, nonatomic) IBOutlet UIView *ViewBorwScore;
//返回画眉
@property (weak, nonatomic) IBOutlet UIButton *ButBackBrow;

@property (weak, nonatomic) IBOutlet UIView *ViewBackBrow;//View

@property (weak, nonatomic) IBOutlet UIView *ViewXian1;//线1
@property (weak, nonatomic) IBOutlet UIView *ViewXian2;//线2
@property (weak, nonatomic) IBOutlet UIView *ViewXian3;//线3
@property (weak, nonatomic) IBOutlet UIView *ViewXian4;//线4
@property (weak, nonatomic) IBOutlet UIView *ViewXian5;//线5
@property (weak, nonatomic) IBOutlet UIView *ViewXian6;//线6
@property (weak, nonatomic) IBOutlet UIButton *ButColor1;//颜色1
@property (weak, nonatomic) IBOutlet UIButton *ButColor2;//颜色2
@property (weak, nonatomic) IBOutlet UIView *ViewCarp;//网格图片
@property (weak, nonatomic) IBOutlet UIButton *ButLock;
@property (weak, nonatomic) IBOutlet UIImageView *ImageRot1;//转1
@property (weak, nonatomic) IBOutlet UIImageView *ImageRot2;//转2
@property (weak, nonatomic) IBOutlet UIButton *ButRot;
@property (weak, nonatomic) IBOutlet UIView *ViewImageRot;

@end
