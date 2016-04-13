//
//  InternetService.h
//  UI_Class_16（网络请求）
//
//  Created by dllo on 16/1/11.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataBlock) (NSData *data);


@interface InternetService : NSObject

+ (void)getDataFromGetUrlMethod:(NSString *)strUrl
                           Data:(DataBlock)dataBlock;

+ (void)getDataFromPostUrlMethod:(NSString *)strUrl
                         UrlBody:(NSString *)urlBody
                           Data:(DataBlock)dataBlock;
@end
