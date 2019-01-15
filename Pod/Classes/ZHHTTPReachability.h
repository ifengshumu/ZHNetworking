//
//  ZHHTTPReachability.h
//  ZHNetworking
//
//  Created by Lee on 2016/10/9.
//  Copyright © 2016年 leezhihua All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHHTTPReachability : NSObject

///是否连接WiFi
+ (BOOL)isReachableWiFi;
///是否连接移动网络
+ (BOOL)isReachableCellular;
///是否网络可用
+ (BOOL)isReachableNetwork;
///处理网络连接
+ (void)handlerNetworkReachable:(void(^)(BOOL reachable))handler;

@end

