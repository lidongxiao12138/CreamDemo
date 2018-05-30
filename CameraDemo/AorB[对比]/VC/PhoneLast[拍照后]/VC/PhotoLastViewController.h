//
//  PhotoLastViewController.h
//  CameraDemo
//
//  Created by edz on 2018/5/22.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoLastViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ButGoBack;
@property (weak, nonatomic) IBOutlet UIButton *ButWangGe;
@property (weak, nonatomic) IBOutlet UIButton *ButSave;
@property (weak, nonatomic) IBOutlet UIImageView *ImagePhoto;
@property (weak, nonatomic) IBOutlet UIView *ViewXian1;
@property (weak, nonatomic) IBOutlet UIView *ViewXian2;
@property (weak, nonatomic) IBOutlet UIView *ViewXian3;
@property (weak, nonatomic) IBOutlet UIView *ViewXian4;
@property (weak, nonatomic) IBOutlet UIView *ViewXian5;
@property (weak, nonatomic) IBOutlet UIView *ViewXian6;

@property (weak, nonatomic) IBOutlet UIView *ViewCaper;

@property (nonatomic, strong)UIImage * PhotoImage;

@property (weak, nonatomic) IBOutlet UIButton *ButLock;

@property (weak, nonatomic) IBOutlet UIImageView *ImageRot1;
@property (weak, nonatomic) IBOutlet UIImageView *ImageRot2;
@property (weak, nonatomic) IBOutlet UIButton *ButRot;

@property (weak, nonatomic) IBOutlet UIView *ViewImageRot;

@end
