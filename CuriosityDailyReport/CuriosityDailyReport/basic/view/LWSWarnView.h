//
//  LWSWarnView.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/14.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^disappearBlock)(BOOL);

@interface LWSWarnView : UIView

@property (nonatomic , copy)NSString *warnString;
@property (nonatomic , copy)UIImage *image;

@property (nonatomic , copy)disappearBlock disBlock;

@end
