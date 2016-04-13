//
//  LWSCoculateSize.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/14.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LWSCoculateSize : NSObject

/**根据label的内容获取label的长度 */
+ (CGFloat)getCurrentLabelHeightByLabelText:(NSString *)text
                                       Font:(UIFont *)font
                                 LabelWidth:(CGFloat)width;

+ (CGFloat)getCurrentLabelWidthByLabelText:(NSString *)text
                                      Font:(UIFont *)font
                               LabelHeight:(CGFloat)height;

@end
