//
//  LWSModelCategory.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/16.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSModel.h"

@interface LWSModelCategory : LWSModel

@property (nonatomic , retain)NSNumber *CID;
@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *normal_hl;
@property (nonatomic , copy)NSString *image_lab;
@property (nonatomic , copy)NSString *image_experiment;

@end
