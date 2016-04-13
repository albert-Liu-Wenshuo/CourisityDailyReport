//
//  LWSDataFile.h
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWSDataFile : NSObject

/**在这个工具类中使用模型类名作为存储的路径的文件名部分 */

+ (BOOL)writeDicFileToCache:(NSDictionary *)dicFile
                  ClassName:(NSString *)name;

+ (NSDictionary *)getDicFileFromCacheWithClassName:(NSString *)name;

@end
