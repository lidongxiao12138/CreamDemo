//
//  SupperViewController.h
//  CameraDemo
//
//  Created by edz on 2018/5/21.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupperViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *ViewChoose;//View选项
@property (weak, nonatomic) IBOutlet UIButton *ButDesign;//设计
@property (weak, nonatomic) IBOutlet UIButton *ButAorB;//对比

@property (weak, nonatomic) IBOutlet UIView *ViewCycle;//滚动
@property (weak, nonatomic) IBOutlet UIImageView *ImageHeadView;//头部

@end
