//
//  LWSDataAnaly.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWSNetWorkTool.h"

typedef void(^myBlock)(NSMutableArray *result);

@interface LWSDataAnaly : NSObject

+ (void)getFirstPagerModelsWithUrl:(NSString *)strUrl
                            Result:(myBlock)results;

+ (void)getFirstPagerCellModelsWithUrl:(NSString *)strUrl Result:(myBlock)results;

@end
