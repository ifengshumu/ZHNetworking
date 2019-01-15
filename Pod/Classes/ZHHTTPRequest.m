//
//  ZHHTTPRequest.m
//  ZHNetworking
//
//  Created by Lee on 2016/10/8.
//  Copyright © 2016年 leezhihua All rights reserved.
//

#import "ZHHTTPRequest.h"

@implementation ZHHTTPRequest

+ (instancetype)requestGET:(NSString *)URLString {
    return [self requestWithType:ZHHTTPRequestTypeGET url:URLString params:nil];
}

+ (instancetype)requestGET:(NSString *)URLString params:(NSDictionary *)params {
    return [self requestWithType:ZHHTTPRequestTypeGET url:URLString params:params];
}

+ (instancetype)requestPOST:(NSString *)URLString {
    return [self requestWithType:ZHHTTPRequestTypePOST url:URLString params:nil];
}

+ (instancetype)requestPOST:(NSString *)URLString params:(NSDictionary *)params {
    return [self requestWithType:ZHHTTPRequestTypePOST url:URLString params:params];
}

+ (instancetype)requestPOSTMultipart:(NSString *)URLString multipartConstruct:(void (^)(id<AFMultipartFormData>))construct {
    ZHHTTPRequest *request = [self requestWithType:ZHHTTPRequestTypePOSTMultipart url:URLString params:nil];
    request.multipartConstruct = construct;
    return request;
}

+ (instancetype)requestPOSTMultipart:(NSString *)URLString params:(NSDictionary *)params multipartConstruct:(void (^)(id<AFMultipartFormData>))construct {
    ZHHTTPRequest *request = [self requestWithType:ZHHTTPRequestTypePOSTMultipart url:URLString params:params];
    request.multipartConstruct = construct;
    return request;
}

+ (instancetype)requestWithType:(ZHHTTPRequestType)type url:(NSString *)URLString params:(NSDictionary *)params {
    ZHHTTPRequest *request = [[ZHHTTPRequest alloc] init];
    request.requestType = type;
    request.url = URLString;
    request.params = params;
    return request;
}

@end
