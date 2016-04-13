//
//  LWSModelList.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSModel.h"

@interface LWSModelList : LWSModel

@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *strUrl;
@property (nonatomic , copy)NSString *iconUrl;

- (instancetype)initWithTitle:(NSString *)title
                       StrUrl:(NSString *)strUrl
                      IconUrl:(NSString *)iconUrl;

@end
