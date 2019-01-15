//
//  ZHHTTPManager.h
//  ZHNetworking
//
//  Created by Lee on 2016/10/8.
//  Copyright © 2016年 leezhihua All rights reserved.
//  网络请求

#import <Foundation/Foundation.h>


@class ZHHTTPRequest;
@interface ZHHTTPManager : NSObject

/**
 网络请求

 @param request 请求方法、url、参数等
 @param success 成功回调，已JSON序列化为数组or字典
 @param failure 失败回调，状态码需和服务端商定，可根据状态码进行相应的文字提示
 @note  statusCode 400以上为客户端错误，500以上为服务端错误
        status 如果代理ZHHTTPConfigDelegate实现，则取其实现的文字，否则取默认
 */
+ (void)request:(ZHHTTPRequest *)request success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure;

/**
 网络请求，带进度
 */
+ (void)request:(ZHHTTPRequest *)request progress:(void(^)(CGFloat progress))progress success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure;

/**
 下载，存储在Library

 @param url 下载url
 @param progress 进度
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)downloadWithURLString:(NSString *)url progress:(void(^)(CGFloat progress))progress success:(void(^)(NSURLResponse *response, NSURL *filePath))success failure:(void(^)(NSError *error))failure;

/**
 下载，指定存储URL

 @param url 下载路径
 @param progress 进度，0-1
 @param destination 存储URL
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)downloadWithURLString:(NSString *)url progress:(void(^)(CGFloat progress))progress destination:(NSURL *(^)(NSString *suggestedFilename))destination success:(void(^)(NSURLResponse *response, NSURL *filePath))success failure:(void(^)(NSError *error))failure;
@end

