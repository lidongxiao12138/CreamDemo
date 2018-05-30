//
//  BorwCollectionViewCell.m
//  CameraDemo
//
//  Created by edz on 2018/5/9.
//  Copyright © 2018年 ldx. All rights reserved.
//

#import "BorwCollectionViewCell.h"

@implementation BorwCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)getInfo:(NSString *)Str
{
    if ([Str isEqual: @"1"]) {
        [self.ImageBrow setBackgroundColor:[UIColor blackColor]];
    }else if ([Str isEqual: @"2"])
    {
        [self.ImageBrow setBackgroundColor:[UIColor brownColor]];
    }
}
@end
