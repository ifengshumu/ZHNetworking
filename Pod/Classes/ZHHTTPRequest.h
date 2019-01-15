//
//  ZHHTTPRequest.h
//  ZHNetworking
//
//  Created by Lee on 2016/10/8.
//  Copyright © 2016年 leezhihua All rights reserved.
//  配置请求方式、URL、参数、请求头

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLRequestSerialization.h>

typedef NS_ENUM(NSUInteger, ZHHTTPRequestType) {
    ZHHTTPRequestTypeGET,
    ZHHTTPRequestTypePOST,
    ZHHTTPRequestTypePOSTMultipart,
    ZHHTTPRequestTypePUT,
    ZHHTTPRequestTypeDELETE,
};

@interface ZHHTTPRequest : NSObject

///请求方式
@property (nonatomic, assign) ZHHTTPRequestType requestType;
///请求url，配合config里的baseURL
@property (nonatomic, copy) NSString *url;
///请求参数
@property (nonatomic, copy) NSDictionary *params;
///上传数据
@property (nonatomic, copy) void(^multipartConstruct)(id<AFMultipartFormData> formData);
///模拟Response数据
@property (nonatomic, strong) id mockResponse;

///初始化GET请求
+ (instancetype)requestGET:(NSString *)URLString;
///初始化GET请求，带参数
+ (instancetype)requestGET:(NSString *)URLString params:(NSDictionary *)params;
///初始化POST请求
+ (instancetype)requestPOST:(NSString *)URLString;
///初始化POST请求，带参数
+ (instancetype)requestPOST:(NSString *)URLString params:(NSDictionary *)params;
///初始化POSTMultipart请求，带参数
+ (instancetype)requestPOSTMultipart:(NSString *)URLString multipartConstruct:(void(^)(id<AFMultipartFormData> formData))construct;
///初始化POSTMultipart请求，带参数
+ (instancetype)requestPOSTMultipart:(NSString *)URLString params:(NSDictionary *)params multipartConstruct:(void(^)(id<AFMultipartFormData> formData))construct;


@end
