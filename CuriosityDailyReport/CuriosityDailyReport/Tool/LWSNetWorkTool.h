//
//  LWSNetWorkTool.h
//  WeiXin
//
//  Created by dllo on 16/2/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//返回值类型枚举
typedef NS_ENUM(NSUInteger, ResponseType) {
    ResponseTypeDATA,
    ResponseTypeJSON,
    ResponseTypeXML,
};

//body体的类型
typedef NS_ENUM(NSUInteger, BodyType) {
    BodyTypeJSONString,
    BodyTypeNormal,
};



typedef void(^ProgressBlock)(NSProgress *progress);
typedef void(^SuccessBlock)(id result);
typedef void(^FailedBlock)(NSError *error);

@interface LWSNetWorkTool : NSObject



/**
 *  GET请求
 *
 *  @param url          url
 *  @param parameter    参数
 *  @param httpHrader   请求头
 *  @param responseType 返回值类型
 *  @param process      进度
 *  @param success      成功
 *  @param failed       失败
 */

+ (void)getWithURL:(NSString *)url
         Parameter:(NSDictionary *)parameter
        HttpHrader:(NSDictionary <NSString * , NSString *> *)httpHrader
      ResponseType:(ResponseType)responseType
          Progress:(ProgressBlock)process
           Success:(SuccessBlock)success
            Failed:(FailedBlock)failed;




/**
 *  post请求
 *
 *  @param url          url
 *  @param body         body
 *  @param bodyType     body类型
 *  @param httpHrader   请求头
 *  @param responseType 返回值类型
 *  @param process      进度
 *  @param success      成功
 *  @param failed       失败
 */

+ (void)postWithURL:(NSString *)url
               Body:(id)body
           BodyType:(BodyType)bodyType
        HttpHrader:(NSDictionary <NSString * , NSString *> *)httpHrader
      ResponseType:(ResponseType)responseType
          Progress:(ProgressBlock)process
           Success:(SuccessBlock)success
            Failed:(FailedBlock)failed;


@end
