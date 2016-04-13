//
//  LWSListPager.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "ViewController.h"

typedef void(^MyBlock)(NSString *);

@interface LWSListPager : ViewController

@property (nonatomic , retain)NSMutableArray *models;
@property (nonatomic , copy)MyBlock block;

@end
