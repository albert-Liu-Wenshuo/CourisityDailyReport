//
//  LWSMenuPagerViewController.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/21.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "ViewController.h"

typedef void(^effectBlock)(BOOL);
typedef void(^urlBlock)(NSString *);

@interface LWSMenuPagerViewController : ViewController

@property (nonatomic , copy)effectBlock block;
@property (nonatomic , copy)urlBlock myUrlBlock;

@end
