

#import "XJJNetWorkTool.h"
#import "AFNetworking.h"
#import <netinet/in.h>

#import "XJJAccount.h"
#import "XJJAccountTool.h"
#import "XJJUtilityTool.h"
#import "MBProgressHUD.h"

#define XJJtimeoutInterval 15
@interface XJJNetWorkTool ()

@property (nonatomic,strong)AFHTTPSessionManager *manager;

@end

@implementation XJJNetWorkTool

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        //设置超时时间
        _manager.requestSerializer.timeoutInterval = XJJtimeoutInterval;
        
        //设置请求提交的参数格式
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
    }
    
    return _manager;
    
}

#pragma mark - 创建网络工具类单例
+ (instancetype)shareNetWorkTool{
    static dispatch_once_t onceToken;
    static XJJNetWorkTool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[XJJNetWorkTool alloc] init];
    });
    return instance;
}


- (NSURLSessionDataTask *)sendHttpRequestWithUrl:(NSString *)urlString parameter:(id)parameter Method:(XJJHttpMethod)method
                  successBlock:(void(^)(NSDictionary *dicData,BOOL isEmpty))successBlock fail:(void(^)(NSError *error))failBlock{
    if([self isNetworkReachable] == NO){
        NSError *error = [[NSError alloc] initWithDomain:@"" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"网络未连接!请先配置网络!"                                                                      forKey:NSLocalizedDescriptionKey]];
        [XJJUtilityTool alertWithTitle:@"提示" msg:@"网络未连接!请先配置网络!"];
        failBlock(error);
        return nil;
    }
    
    NSDictionary *dic = parameter;
    
    NSURLSessionDataTask *task = nil;
    if (method == kXJJGET) {
        task = [self.manager GET:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            //XJJLog(@"%@",downloadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject){
                successBlock(responseObject,NO);
            } else {
                successBlock(@{@"msg":@"暂无数据"}, YES);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == - 1001) {
//                [XJJUtilityTool alertWithTitle:@"提示" msg:@"当前网络不稳定"];
            }
            failBlock(error);
        }];
    }else if(method == KXJJPOST){
        AFHTTPSessionManager *manager = self.manager;
        task = [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject){
                successBlock(responseObject,NO);
            } else {
                successBlock(@{@"msg":@"暂无数据"}, YES);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == - 1001) {
                //                    [XJJUtilityTool alertWithTitle:@"提示" msg:@"当前网络不稳定"];
            }
            failBlock(error);
        }];
        [task resume];
    }else if(method == KXJJPUT){
       task = [self.manager PUT:urlString parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject){
                successBlock(responseObject,NO);
            } else {
                successBlock(@{@"msg":@"暂无数据"}, YES);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == - 1001) {
//                [XJJUtilityTool alertWithTitle:@"提示" msg:@"当前网络不稳定"];
            }
            failBlock(error);
        }];
    }else{
        
      task = [self.manager DELETE:urlString parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject){
                successBlock(responseObject,NO);
            } else {
                successBlock(@{@"msg":@"暂无数据"}, YES);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == - 1001) {
//                [XJJUtilityTool alertWithTitle:@"提示" msg:@"当前网络不稳定"];
            }
            failBlock(error);
        }];
    }
    return task;
}

- (BOOL)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


@end
