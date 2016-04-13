//
//  LWSFirstImageCell.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSTableViewCell.h"
#import "LWSModelFirst.h"

#define CONTECTTYPE @"internetContectType"
#define CONTECTWIFI @"wifi"
#define CONTECTMOBILE @"mobile"
#define CONTECTNONE @"no"

@interface LWSFirstImageCell : LWSTableViewCell

@property (nonatomic , retain)LWSModelFirst *model;

@end
