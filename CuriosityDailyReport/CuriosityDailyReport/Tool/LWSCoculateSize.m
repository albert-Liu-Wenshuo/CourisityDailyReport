//
//  LWSCoculateSize.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/14.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSCoculateSize.h"

@implementation LWSCoculateSize

+ (CGFloat)getCurrentLabelHeightByLabelText:(NSString *)text
                                       Font:(UIFont *)font
                                 LabelWidth:(CGFloat)width{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize labelsize = [text boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return labelsize.height;
}

+ (CGFloat)getCurrentLabelWidthByLabelText:(NSString *)text
                                      Font:(UIFont *)font
                               LabelHeight:(CGFloat)height{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize labelsize = [text boundingRectWithSize:CGSizeMake(2000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return labelsize.width;
}

@end
