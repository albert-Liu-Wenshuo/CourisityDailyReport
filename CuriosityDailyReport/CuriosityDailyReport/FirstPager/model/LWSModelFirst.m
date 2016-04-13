//
//  LWSModelFirst.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/16.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSModelFirst.h"
#import "LWSModelCategory.h"

@implementation LWSModelFirst

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"category"]) {
        _category = [LWSModelCategory modelWithDic:value];
    }else
        [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [super setValue:value forUndefinedKey:key];
    if ([key isEqualToString:@"description"]) {
        _summary = value;
    }
}

@end
