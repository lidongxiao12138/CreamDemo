//
//  LoginModel.m
//  BookingCar
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 LDX. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:self.token forKey:@"token"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
    
        self.token = [aDecoder decodeObjectForKey:@"token"];
        
    }
    return self;
}

@end
