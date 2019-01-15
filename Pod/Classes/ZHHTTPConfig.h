//
//  ZHHTTPRequest.h
//  ZHNetworking
//
//  Created by Lee on 2016/10/8.
//  Copyright © 2016年 leezhihua All rights reserved.
//  配置网络请求，应用生命周期内只需调用一次

#import <Foundation/Foundation.h>
#import <AFNetworking/AFSecurityPolicy.h>

@protocol ZHHTTPConfigDelegate <NSObject>

- (NSString *)handlerNetworkStatusCode:(NSInteger)statusCode;

@end

@interface ZHHTTPConfig : NSObject
///一般为host，如果设置，request的url必须为去除host的部分，否则必须为完整的url
@property (nonatomic, copy) NSString *baseURL;
///超时时间，默认60s
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
///请求头
@property (nonatomic, copy) NSDictionary *httpHeaderField;
///https证书名称
@property (nonatomic, copy) NSString *cerName;
///代理
@property (nonatomic, weak) id<ZHHTTPConfigDelegate> delegate;

///单利
+ (instancetype)defaultConfig;

///配置https证书
- (AFSecurityPolicy *)configSecurityPolicy;
@end
