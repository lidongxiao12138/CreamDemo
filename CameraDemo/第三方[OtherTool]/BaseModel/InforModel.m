//
//  InforModel.m
//  BookingCar
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 LDX. All rights reserved.
//

#import "InforModel.h"

@implementation InforModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.idTemp = value;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.idTemp forKey:@"id"];
    [aCoder encodeObject:self.create_time forKey:@"create_time"];
    [aCoder encodeObject:self.portrait_image forKey:@"portrait_image"];
    [aCoder encodeObject:self.nick_name forKey:@"nick_name"];
    [aCoder encodeObject:self.article_count forKey:@"article_count"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.company1 forKey:@"company1"];
    [aCoder encodeObject:self.company2 forKey:@"company2"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.points forKey:@"points"];
    [aCoder encodeObject:self.job forKey:@"job"];

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.idTemp = [aDecoder decodeObjectForKey:@"id"];
        self.create_time = [aDecoder decodeObjectForKey:@"create_time"];
        self.portrait_image = [aDecoder decodeObjectForKey:@"portrait_image"];
        self.nick_name = [aDecoder decodeObjectForKey:@"nick_name"];
        self.article_count = [aDecoder decodeObjectForKey:@"article_count"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.company1 = [aDecoder decodeObjectForKey:@"company1"];
        self.company2 = [aDecoder decodeObjectForKey:@"company2"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.points = [aDecoder decodeObjectForKey:@"points"];
        self.job = [aDecoder decodeObjectForKey:@"job"];
        
    }
    return self;
}
@end
