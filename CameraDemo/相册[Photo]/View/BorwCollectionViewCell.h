//
//  BorwCollectionViewCell.h
//  CameraDemo
//
//  Created by edz on 2018/5/9.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorwCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageBrow;
-(void)getInfo:(NSString *)Str;
@end
