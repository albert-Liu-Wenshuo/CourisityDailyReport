//
//  LWSScrollerView.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWSModelFirst.h"

typedef void(^jumpBlock)(LWSModelFirst *model);

@interface LWSScrollerView : UIScrollView

@property (nonatomic , retain)NSMutableArray *models;
@property (nonatomic , copy)jumpBlock block;


@end
