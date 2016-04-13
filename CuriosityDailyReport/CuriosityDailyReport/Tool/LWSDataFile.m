//
//  LWSDataFile.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSDataFile.h"

@implementation LWSDataFile

static NSString *path;

/**将字典转成nsdata的方法 */
//NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                        @"balance", @"key",
//                        @"remaining balance", @"label",
//                        @"45", @"value",
//                        @"USD", @"currencyCode",nil];
//
//NSMutableData *data = [[NSMutableData alloc] init];
//NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//[archiver encodeObject:params forKey:@"Some Key Value"];
//[archiver finishEncoding];


+ (void)initialize{
    path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (BOOL)writeDicFileToCache:(NSDictionary *)dicFile ClassName:(NSString *)name{
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",name];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    /**使用归档的方式实现将字典存入数据 */
    if ([NSKeyedArchiver archiveRootObject:dicFile toFile:filePath]) {
        return YES;
    }else
        return NO;
}

/**获取出错的时候返回一个key为error的内容 */
+ (NSDictionary *)getDicFileFromCacheWithClassName:(NSString *)name{
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",name];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    /**使用归档处理存储的数据也必将使用反归档取出 */
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (dic != nil) {
        return dic;
    }else
    {
        return [NSDictionary dictionaryWithObject:@"null" forKey:@"error"];
    }
    return nil;
}

@end
