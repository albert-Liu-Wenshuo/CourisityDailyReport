//
//  LWSModelFirst.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/16.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSModel.h"

@class LWSModelCategory;

@interface LWSModelFirst : LWSModel

@property (nonatomic , copy)NSString *title;
@property (nonatomic , copy)NSString *summary;
@property (nonatomic , copy)NSString *appview;
@property (nonatomic , copy)NSString *image;
@property (nonatomic , copy)NSString *film_length;
@property (nonatomic , copy)NSString *super_tag;

@property (nonatomic , retain)NSNumber *genre;
@property (nonatomic , retain)NSNumber *publish_time;
@property (nonatomic , retain)NSNumber *comment_count;
@property (nonatomic , retain)NSNumber *praise_count;
@property (nonatomic , retain)NSNumber *type;
/**用来判断添加的是不是iamgecell */
@property (nonatomic , assign)BOOL imageType;


@property (nonatomic , retain)LWSModelCategory *category;

@end
