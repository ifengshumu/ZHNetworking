# ZHNetworking
iOS网络操作：各种方式（GET、POST等）的请求、上传、下载

## 支持cocoapods导入
```
pod 'ZHNetworking'
```

## 使用前可以使用ZHHTTPConfig对请求进行配置
```
//一般为host，如果设置，request的url必须为去除host的部分，否则必须为完整的url
@property (nonatomic, copy) NSString *baseURL;
///超时时间，默认60s
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
///请求头
@property (nonatomic, copy) NSDictionary *httpHeaderField;
///https证书名称
@property (nonatomic, copy) NSString *cerName;
///代理
@property (nonatomic, weak) id<ZHHTTPConfigDelegate> delegate;
```
```
///配置https证书
- (AFSecurityPolicy *)configSecurityPolicy;
```

## 网络连接
```
[ZHHTTPReachability handlerNetworkReachable:^(BOOL reachable) {
    NSLog(@"网络连接：%d", reachable);
}];
```

## 请求
```
ZHHTTPRequest *request = [ZHHTTPRequest requestGET:@"https://www.apple.com"];
[ZHHTTPManager request:request success:^(id response) {
    
} failure:^(NSInteger statusCode, NSString *status) {
    
}];
```
### 模拟请求
```
ZHHTTPRequest *request = [ZHHTTPRequest requestGET:@"https://www.apple.com"];
request.mockResponse = @{};
[ZHHTTPManager request:request success:^(id response) {

} failure:^(NSInteger statusCode, NSString *status) {

}];
```

## 上传
```
UIImage *image = nil;
ZHHTTPRequest *request = [ZHHTTPRequest requestPOSTMultipart:@"https://www.apple.com" params:@{@"id":@123} multipartConstruct:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"file" fileName:@"20111111.jpg" mimeType:@"image/jpeg"];
    }];
[ZHHTTPManager request:request success:^(id response) {
    
} failure:^(NSInteger statusCode, NSString *status) {
    
}];
```

## 下载
```
//存储在Library
[ZHHTTPManager downloadWithURLString:@"" progress:^(CGFloat progress) {
    NSLog(@"下载进度：%.2lf", progress*100.0);
} success:^(NSURLResponse *response, NSURL *filePath) {
    
} failure:^(NSError *error) {
    
}];
//指定存储URL
[ZHHTTPManager downloadWithURLString:@"" progress:^(CGFloat progress) {
    NSLog(@"下载进度：%.2lf", progress*100.0);
} destination:^NSURL *(NSString *suggestedFilename) {
    return [NSURL URLWithString:@""];
} success:^(NSURLResponse *response, NSURL *filePath) {
    
} failure:^(NSError *error) {
    
}];
```
