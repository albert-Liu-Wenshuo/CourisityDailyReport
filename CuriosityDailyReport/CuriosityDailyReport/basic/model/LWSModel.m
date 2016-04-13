//
//  LWSModel.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/16.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSModel.h"

@implementation LWSModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDic:(NSDictionary *)dic{
    return [[super alloc] initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
//    else
//        NSLog(@"UndefinedKey = %@",key);
}

@end
