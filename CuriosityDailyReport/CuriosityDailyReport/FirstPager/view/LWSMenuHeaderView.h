//
//  LWSMenuHeaderView.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSView.h"

@protocol LWSMenuHeaderViewDelegate <NSObject>



@end

@interface LWSMenuHeaderView : LWSView

@property (nonatomic , assign)id<LWSMenuHeaderViewDelegate> delegate;
@property (nonatomic , retain)UITextField *textSearch;


@end
