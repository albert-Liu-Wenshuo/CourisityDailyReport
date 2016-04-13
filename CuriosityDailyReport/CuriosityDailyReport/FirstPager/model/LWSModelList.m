//
//  LWSModelList.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSModelList.h"

@implementation LWSModelList

- (instancetype)initWithTitle:(NSString *)title StrUrl:(NSString *)strUrl IconUrl:(NSString *)iconUrl{
    self = [super init];
    if (self) {
        _title = title;
        _iconUrl = iconUrl;
        _strUrl = strUrl;
    }
    return self;
}

@end
