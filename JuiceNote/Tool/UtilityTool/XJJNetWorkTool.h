
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,XJJHttpMethod) {
    kXJJGET, //GET 请求
    KXJJPOST,//POST 请求
    KXJJPUT, //PUT 请求
    KXJJDELETE
};//请求方式枚举

@interface XJJNetWorkTool : NSObject

+ (instancetype)shareNetWorkTool;

- (NSURLSessionDataTask *)sendHttpRequestWithUrl:(NSString *)urlString parameter:(id)parameter Method:(XJJHttpMethod)method
                  successBlock:(void(^)(NSDictionary *dicData,BOOL isEmpty))successBlock fail:(void(^)(NSError *error))failBlock;

- (BOOL)isNetworkReachable;



@end
