//
//  ZHHTTPManager.m
//  ZHNetworking
//
//  Created by Lee on 2016/10/8.
//  Copyright © 2016年 leezhihua All rights reserved.
//

#import "ZHHTTPManager.h"
#import "ZHHTTPRequest.h"
#import "ZHHTTPConfig.h"
#import <AFNetworking/AFNetworking.h>

@interface ZHHTTPManager ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

static ZHHTTPManager *netwotk = nil;
@implementation ZHHTTPManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netwotk = [[self alloc] init];
    });
    return netwotk;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        AFHTTPSessionManager *manager = nil;
        ZHHTTPConfig *config = [ZHHTTPConfig defaultConfig];
        if (config.baseURL && config.baseURL.length) {
            manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:config.baseURL]];
        } else {
            manager = [AFHTTPSessionManager manager];
        }
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = config.requestTimeoutInterval;
        [config.httpHeaderField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
        if ([config configSecurityPolicy]) {
            manager.securityPolicy = [config configSecurityPolicy];
        }
        self.manager = manager;
    }
    return self;
}

+ (void)request:(ZHHTTPRequest *)request success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure {
    return [self request:request progress:nil success:success failure:failure];
}

+ (void)request:(ZHHTTPRequest *)request progress:(void(^)(CGFloat progress))progress success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure {
    switch (request.requestType) {
        case ZHHTTPRequestTypeGET:
            if (request.mockResponse) {
                success(request.mockResponse);
            } else {
                [self requestGET:request progress:progress success:success failure:failure];
            }
            break;
        case ZHHTTPRequestTypePOST:
            if (request.mockResponse) {
                success(request.mockResponse);
            } else {
                [self requestPOST:request progress:progress success:success failure:failure];
            }
            break;
        case ZHHTTPRequestTypePOSTMultipart:
            if (request.mockResponse) {
                success(request.mockResponse);
            } else {
                [self requestPOSTMultipart:request progress:progress success:success failure:failure];
            }
            break;
        case ZHHTTPRequestTypePUT:
            if (request.mockResponse) {
                success(request.mockResponse);
            } else {
                [self requestPUT:request success:success failure:failure];
            }
            break;
        case ZHHTTPRequestTypeDELETE:
            if (request.mockResponse) {
                success(request.mockResponse);
            } else {
                [self requestDELETE:request success:success failure:failure];
            }
            break;
        default:
            break;
    }
}

+ (void)requestGET:(ZHHTTPRequest *)request progress:(void(^)(CGFloat progress))progress success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure {
    [[ZHHTTPManager sharedManager].manager GET:request.url parameters:request.params progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id res = [self serializationResponse:responseObject];
        success(res);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger code = [self checkDataTask:task];
        NSString *status = [self checkStatuCode:code];
        failure(code, status);
    }];
}

+ (void)requestPOST:(ZHHTTPRequest *)request progress:(void(^)(CGFloat progress))progress success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure {
    [[ZHHTTPManager sharedManager].manager POST:request.url parameters:request.params progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id res = [self serializationResponse:responseObject];
        success(res);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger code = [self checkDataTask:task];
        NSString *status = [self checkStatuCode:code];
        failure(code, status);
    }];
}

+ (void)requestPOSTMultipart:(ZHHTTPRequest *)request progress:(void(^)(CGFloat progress))progress success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure {
    [[ZHHTTPManager sharedManager].manager POST:request.url parameters:request.params constructingBodyWithBlock:request.multipartConstruct progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id res = [self serializationResponse:responseObject];
        success(res);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger code = [self checkDataTask:task];
        NSString *status = [self checkStatuCode:code];
        failure(code, status);
    }];
}

+ (void)requestPUT:(ZHHTTPRequest *)request success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure {
    [[ZHHTTPManager sharedManager].manager PUT:request.url parameters:request.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id res = [self serializationResponse:responseObject];
        success(res);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger code = [self checkDataTask:task];
        NSString *status = [self checkStatuCode:code];
        failure(code, status);
    }];
}

+ (void)requestDELETE:(ZHHTTPRequest *)request success:(void(^)(id response))success failure:(void(^)(NSInteger statusCode, NSString *status))failure {
    [[ZHHTTPManager sharedManager].manager DELETE:request.url parameters:request.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id res = [self serializationResponse:responseObject];
        success(res);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger code = [self checkDataTask:task];
        NSString *status = [self checkStatuCode:code];
        failure(code, status);
    }];
}

+ (id)serializationResponse:(id)responseObject {
    if ([NSJSONSerialization isValidJSONObject:responseObject]) {
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (json && !error) {
            return json;
        } else {
            return responseObject;
        }
    } else {
        return responseObject;
    }
}

//错误码，需要和服务端对接，eg:408-请求超时
+ (NSInteger)checkDataTask:(NSURLSessionDataTask *)task {
    NSInteger code = 0;
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        code = response.statusCode;
    }
    return code;
}
+ (NSString *)checkStatuCode:(NSInteger)statusCode {
    ZHHTTPConfig *config = [ZHHTTPConfig defaultConfig];
    if (config.delegate && [config.delegate respondsToSelector:@selector(handlerNetworkStatusCode:)]) {
        return [config.delegate handlerNetworkStatusCode:statusCode];
    } else {
        NSString *status = nil;
        if (statusCode >= 400 && statusCode < 500) {
            switch (statusCode) {
                    case 401:
                    status = @"需要用户名和密码进行认证";
                    break;
                    case 403:
                    status = @"请求被禁止";
                    break;
                    case 404:
                    status = @"请求不存在";
                    break;
                    case 405:
                    status = @"请求方式不正确";
                    break;
                    case 408:
                    status = @"请求超时";
                    break;
                default: status = @"请求出错";
                    break;
            }
        } else if (statusCode >= 500 && statusCode <= 600) {
            status = @"服务器异常";
        } else {
            status = @"当前网络不可用，请检查网络";
        }
        return status;
    }
}


+ (void)downloadWithURLString:(NSString *)url progress:(void (^)(CGFloat))progress success:(void (^)(NSURLResponse *, NSURL *))success failure:(void (^)(NSError *))failure {
    [self downloadWithURLString:url progress:progress destination:^NSURL *(NSString *suggestedFilename) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        path = [path stringByAppendingPathComponent:suggestedFilename];
        NSURL *url = [NSURL URLWithString:path];
        return url;
    } success:success failure:failure];
}

+ (void)downloadWithURLString:(NSString *)url progress:(void(^)(CGFloat progress))progress destination:(NSURL *(^)(NSString *suggestedFilename))destination success:(void(^)(NSURLResponse *response, NSURL *filePath))success failure:(void(^)(NSError *error))failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *task = [[ZHHTTPManager sharedManager].manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destination(response.suggestedFilename);
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        } else {
            success(response, filePath);
        }
    }];
    [task resume];
    
}

@end
