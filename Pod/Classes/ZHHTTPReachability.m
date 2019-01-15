//
//  ZHHTTPReachability.m
//  ZHNetworking
//
//  Created by Lee on 2016/10/9.
//  Copyright © 2016年 leezhihua All rights reserved.
//

#import "ZHHTTPReachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface ZHHTTPReachability ()
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;
@property (nonatomic, copy) void(^handlerNetworkReachable)(BOOL reachable);
@end


static ZHHTTPReachability *reachability = nil;
@implementation ZHHTTPReachability

+ (instancetype)defaultReachability {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [[self alloc] init];
    });
    return reachability;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        self.manager = manager;
    }
    return self;
}

- (void)networkStatusChange:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    AFNetworkReachabilityStatus status = [userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) {
        self.handlerNetworkReachable(NO);
    } else {
        self.handlerNetworkReachable(YES);
    }
}

+ (void)handlerNetworkReachable:(void (^)(BOOL))handler {
    [ZHHTTPReachability defaultReachability].handlerNetworkReachable = handler;
}

+ (BOOL)isReachableWiFi {
    return [[ZHHTTPReachability defaultReachability].manager isReachableViaWiFi];
}
+ (BOOL)isReachableCellular {
    return [[ZHHTTPReachability defaultReachability].manager isReachableViaWWAN];
}
+ (BOOL)isReachableNetwork {
    return [[ZHHTTPReachability defaultReachability].manager isReachable];
}


@end
