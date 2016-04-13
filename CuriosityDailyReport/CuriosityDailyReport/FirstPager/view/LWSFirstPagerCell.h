//
//  LWSFirstPagerCell.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/18.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWSModelFirst.h"
#import "LWSTableViewCell.h"

#define CONTECTTYPE @"internetContectType"
#define CONTECTWIFI @"wifi"
#define CONTECTMOBILE @"mobile"
#define CONTECTNONE @"no"

/**继承了基类 */
@interface LWSFirstPagerCell : LWSTableViewCell

@property (nonatomic , retain)LWSModelFirst *model;

@end
