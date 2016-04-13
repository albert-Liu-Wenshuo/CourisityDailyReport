//
//  LWSDataAnaly.m
//  CuriosityDailyReport
//
//  Created by dllo on 16/3/17.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSDataAnaly.h"
#import "LWSDataFile.h"
#import "LWSScrollerView.h"
#import "LWSFirstPager.h"

@implementation LWSDataAnaly

+ (void)getFirstPagerModelsWithUrl:(NSString *)strUrl Result:(myBlock)results{
    NSMutableArray __block *array;
    [LWSNetWorkTool getWithURL:strUrl Parameter:nil  HttpHrader:nil ResponseType:ResponseTypeJSON Progress:^(NSProgress *progress) {
        NSLog(@"网页数据加载成功");
    } Success:^(id result) {
        /**在这添加成功获取数据的方法 */
        NSDictionary *JSON = result;
        /**这里可以判断写入文件操作是否成功 , 存储的文件名是显示的类的文件名
           获取对象的类名：系统中提供一个方法：NSLog(@"%s",object_getClassName(view));*/
        LWSScrollerView *view = [[LWSScrollerView alloc] init];
        if ([LWSDataFile writeDicFileToCache:JSON ClassName:[NSString stringWithFormat:@"%s",object_getClassName(view)]]) {
            NSLog(@"数据缓存写入成功");
        }else
            NSLog(@"数据缓存写入失败");
        array = [self getModelsWithLWSScrollerView:JSON];
        results(array);
    } Failed:^(NSError *error) {
        /**另一种直接获取系统类名的字符串的方法并且不用初始化一个该类的对象 */
        NSDictionary *JSON = [LWSDataFile getDicFileFromCacheWithClassName:NSStringFromClass([LWSScrollerView class])];
        /**获取的是最新一次获取的该数据的模型 */
        array = [self getModelsWithLWSScrollerView:JSON];
        results(array);
    }];
}

+ (NSMutableArray *)getModelsWithLWSScrollerView:(NSDictionary *)JSON{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *response = [JSON valueForKey:@"response"];
    NSArray *banners = [response valueForKey:@"banners"];
    for (NSDictionary *dic in banners) {
        NSDictionary *post = [dic valueForKey:@"post"];
        LWSModelFirst *model = [LWSModelFirst modelWithDic:post];
        model.image = [dic valueForKey:@"image"];
        model.type = [dic valueForKey:@"type"];
        [array addObject:model];
    }
    return array;
}

/**获取首页正文cell的内容 */
+ (void)getFirstPagerCellModelsWithUrl:(NSString *)strUrl Result:(myBlock)results{
    NSMutableArray __block *array;
    [LWSNetWorkTool getWithURL:strUrl Parameter:nil  HttpHrader:nil ResponseType:ResponseTypeJSON Progress:^(NSProgress *progress) {
        NSLog(@"网页数据加载成功");
    } Success:^(id result) {
        /**在这添加成功获取数据的方法 */
        NSDictionary *JSON = result;
        if ([LWSDataFile writeDicFileToCache:JSON ClassName:NSStringFromClass([LWSFirstPager class])]) {
            NSLog(@"数据缓存写入成功");
        }else
            NSLog(@"数据缓存写入失败");
        array = [self getModelsWithLWSFirstPagerCells:JSON];
        results(array);
    } Failed:^(NSError *error) {
        /**另一种直接获取系统类名的字符串的方法并且不用初始化一个该类的对象 */
        NSDictionary *JSON = [LWSDataFile getDicFileFromCacheWithClassName:NSStringFromClass([LWSFirstPager class])];
        /**获取的是最新一次获取的该数据的模型 */
        array = [self getModelsWithLWSFirstPagerCells:JSON];
        results(array);
    }];

}

+ (NSMutableArray *)getModelsWithLWSFirstPagerCells:(NSDictionary *)JSON{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *response = [JSON valueForKey:@"response"];
    NSArray *feeds = [response valueForKey:@"feeds"];
    for (NSDictionary *dic in feeds) {
        NSDictionary *post = [dic valueForKey:@"post"];
        LWSModelFirst *model = [LWSModelFirst modelWithDic:post];
        if ([post valueForKey:@"column"] != nil) {
            model.imageType = YES;
            if (model.image == nil) {
                model.image = [dic valueForKey:@"image"];
                model.type = [dic valueForKey:@"type"];
            }else if (model.appview == nil){
                model.appview = [post valueForKeyPath:@"column.share.url"];
            }
        }else{
            model.image = [dic valueForKey:@"image"];
            model.type = [dic valueForKey:@"type"];
            model.imageType = NO;
        }
        [array addObject:model];
    }
    return array;
}


@end
