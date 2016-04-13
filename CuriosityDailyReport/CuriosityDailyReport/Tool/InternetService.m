//
//  InternetService.m
//  UI_Class_16（网络请求）
//
//  Created by dllo on 16/1/11.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "InternetService.h"

@implementation InternetService

+ (void)getDataFromGetUrlMethod:(NSString *)strUrl
                           Data:(DataBlock)dataBlock{
    NSURL *url = [NSURL URLWithString:strUrl];
    
    //构建单例有三种方法
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dataBlock(data);
        
    }];
    
    [dataTask resume];
    
    
}

+ (void)getDataFromPostUrlMethod:(NSString *)strUrl UrlBody:(NSString *)urlBody Data:(DataBlock)dataBlock{
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    
    [postRequest setHTTPMethod:@"POST"];
    
    [postRequest setHTTPBody:[urlBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dataBlock(data);
    }];
    [dataTask resume];
}

@end
