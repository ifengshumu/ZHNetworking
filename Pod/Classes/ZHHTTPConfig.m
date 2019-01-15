//
//  ZHHTTPRequest.m
//  ZHNetworking
//
//  Created by Lee on 2016/10/8.
//  Copyright © 2016年 leezhihua All rights reserved.
//

#import "ZHHTTPConfig.h"

static ZHHTTPConfig *config = nil;
@implementation ZHHTTPConfig

+ (instancetype)defaultConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
        config.requestTimeoutInterval = 60;
    });
    return config;
}

- (AFSecurityPolicy *)configSecurityPolicy {
    if (self.cerName && self.cerName.length) {
        NSString *file = [[NSBundle mainBundle] pathForResource:self.cerName ofType:@"cer"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        NSSet *setData = [NSSet setWithObject:data];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:setData];
        return policy;
    } else {
        return nil;
    }
}


@end
