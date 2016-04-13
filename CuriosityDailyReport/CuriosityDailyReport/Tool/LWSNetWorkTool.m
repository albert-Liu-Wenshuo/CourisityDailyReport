//
//  LWSNetWorkTool.m
//  WeiXin
//
//  Created by dllo on 16/2/25.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "LWSNetWorkTool.h"

@implementation LWSNetWorkTool

//+ (void)getWithURL:(NSString *)url Parameter:(NSDictionary *)parameter HttpHrader:(NSDictionary <NSString * , NSString *> *)httpHrader{
//    /**初始化sessionManager */
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    /**处理请求头 */
//    for (NSString *key in httpHrader.allKeys) {
//        [manager.requestSerializer setValue:httpHrader[key] forHTTPHeaderField:key];
//    }
//    manager GET:url parameters: progress: success: failure:
//}

+ (void)getWithURL:(NSString *)url Parameter:(NSDictionary *)parameter HttpHrader:(NSDictionary<NSString *,NSString *> *)httpHrader ResponseType:(ResponseType)responseType Progress:(ProgressBlock)process Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    /**1.初始化sessionManager */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**2.处理请求头 */
    for (NSString *key in httpHrader.allKeys) {
        [manager.requestSerializer setValue:httpHrader[key] forHTTPHeaderField:key];
    }
    /**3.处理返回值类型（需要定义一个枚举） */
    /**4.使用switch设置枚举 */
    switch (responseType) {
        case ResponseTypeDATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case ResponseTypeJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case ResponseTypeXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
    }
    /**设置返回值支持的文本类型 */
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil]];
    /**get请求 */
    [manager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        if(process){
             process(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
}

+(void)postWithURL:(NSString *)url Body:(id)body BodyType:(BodyType)bodyType HttpHrader:(NSDictionary<NSString *,NSString *> *)httpHrader ResponseType:(ResponseType)responseType Progress:(ProgressBlock)process Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    /**1.初始化sessionManager */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**2.处理请求头 */
    for (NSString *key in httpHrader.allKeys) {
        [manager.requestSerializer setValue:httpHrader[key] forHTTPHeaderField:key];
    }
    /**3.设置返回值支持的文本类型 */
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil]];
    /**4.使用switch设置枚举 */
    switch (responseType) {
        case ResponseTypeDATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case ResponseTypeJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case ResponseTypeXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
    }

    /**5.处理body类型 */
    switch (bodyType) {
        case BodyTypeJSONString: {
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
                return parameters;
            }];
            break;
        }
        case BodyTypeNormal: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
    }
    /**6.处理post请求 */
    [manager POST:body parameters:url constructingBodyWithBlock:body progress:^(NSProgress * _Nonnull uploadProgress) {
        if (process) {
            success(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failed(error);
        }
    }];

}


@end
