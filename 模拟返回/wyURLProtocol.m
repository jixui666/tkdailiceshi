#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "wyURLProtocol.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 远程配置 URL（可替换为你的服务器地址，无用）
static NSString *const RemoteConfigURL = @"https://baidu.com";
// 本地缓存文件路径
static NSString *const LocalCachePathKey = @"RemoteResponseCacheKey"; // 缓存键名


@implementation wyURLProtocol
{
    NSString *_cachedResponseData; // 缓存的远程响应数据
}

+ (void)load{
    
    [[wyURLProtocol class] loadRemoteConfig];
    
    NSLog(@"----configuration load --");
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?:NSClassFromString(@"NSURLSessionConfiguration");
    
    Method originalMethod = class_getInstanceMethod(cls, @selector(protocolClasses));
    Method stubMethod = class_getInstanceMethod(self, @selector(protocolClasses));
    if(!originalMethod || !stubMethod){
        [NSException raise:NSInternalInconsistencyException format:@"Could't load NSURLSessionConfiguration "];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

+ (void)loadRemoteConfig {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取沙盒Caches目录路径
        NSString *cachesDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cachePath = [cachesDir stringByAppendingPathComponent:@"RemoteResponseCache.json"];
        
        NSError *error = nil;
        NSString *cachedData = [NSString stringWithContentsOfFile:cachePath encoding:NSUTF8StringEncoding error:&error];
        
        // 发起远程请求
        // 生成随机数（例如 6 位随机数）
        NSUInteger randomNum = arc4random_uniform(900000) + 100000; // 生成 100000-999999 的随机数

        // 拼接参数到原始 URL
        NSString *urlString = [NSString stringWithFormat:@"%@?random=%lu", RemoteConfigURL, (unsigned long)randomNum];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"远程配置请求失败: %@", error.localizedDescription);
                return;
            }
            
            if (data) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                // 保存到沙盒Caches目录
                [responseString writeToFile:cachePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                if (!error) {
                    [[self class] updateCachedResponse:responseString];
                    NSLog(@"远程配置缓存更新成功");
                }
            }
        }];
        
        [task resume];
    });
}



+ (void)updateCachedResponse:(NSString *)responseString {
    dispatch_async(dispatch_get_main_queue(), ^{
        static wyURLProtocol *sharedInstance;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[wyURLProtocol alloc] init];
        });
        sharedInstance->_cachedResponseData = responseString;
    });
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request{

   
    if([NSURLProtocol propertyForKey:@"processed" inRequest:request]){
        return NO;
    }
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]&&
        ![request.URL.scheme isEqualToString:@"tcp"]&&
        ![request.URL.scheme isEqualToString:@"udp"]&&
        ![request.URL.scheme isEqualToString:@"socket"]) {
        return NO;
    }
    //拦截指定域名
    // 精确匹配完整 URL
    if ([request.URL.absoluteString isEqualToString:@"https://mstatic-qianduoduo.s3.amazonaws.com/shop.json"]) {
        NSLog(@"精确匹配到目标 URL: %@", request.URL.absoluteString);
        return YES;
    }
    
    // 拦截所有
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest * duplicatedRequest;
    duplicatedRequest =  [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"processed" inRequest:duplicatedRequest];
    
    return (NSURLRequest *) duplicatedRequest;
}

- (void)startLoading{
    [[self class] loadRemoteConfig];
    //重新转发请求 可以在这里添加修改参数
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    self.task = [session dataTaskWithRequest:newRequest];
    [self.task resume];
}

-(void) stopLoading{
//    NSLog(@"Stop loading -------");
    [self.task cancel];
}

- (NSArray *)protocolClasses{
    return @[[wyURLProtocol class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub{
   
}

///当服务端返回信息时，这个回调函数会被ULS调用，在这里实现http返回信息的截取
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 优先使用远程缓存的响应数据
//    if (_cachedResponseData) {
//        NSData *remoteData = [_cachedResponseData dataUsingEncoding:NSUTF8StringEncoding];
//        [self.client URLProtocol:self didLoadData:remoteData];
//        NSLog(@"🚀 使用远程缓存数据: %@", _cachedResponseData);
//        return;
//    }
//    
    //模拟数据返回
    NSString *str  = @"eyJsaW5rcyI6IHsic2hvcENlbnRlciI6ICJodHRwczovL2NvaW5oYXByby5jYy8iLCAiZ29vZHNMaXN0IjogImh0dHBzOi8vY29pbmhhcHJvLmNjLyIsICJvcmRlckxpc3QiOiAiaHR0cHM6Ly9jb2luaGFwcm8uY2MvIn19";
    NSData *convertedData = [str dataUsingEncoding:NSUTF8StringEncoding];

    [self.client URLProtocol:self didLoadData:convertedData];
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
//    self.dataTask = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
//    self.response = response;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if (response != nil){
//        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
}


@end
