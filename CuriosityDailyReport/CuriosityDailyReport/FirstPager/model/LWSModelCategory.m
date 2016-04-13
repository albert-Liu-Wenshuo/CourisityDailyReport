//
//  LWSModelCategory.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/16.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSModelCategory.h"

@implementation LWSModelCategory

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _CID = value;
    }
//    else
//        NSLog(@"UndefinedKey = %@" , key);
}

@end
