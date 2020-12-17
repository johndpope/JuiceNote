

#import <Foundation/Foundation.h>
#import "XJJAccount.h"

@interface XJJAccountTool : NSObject
//存储账号信息
+ (void)saveAccount:(XJJAccount *)account;

//返回账号信息
+ (XJJAccount *)account;

//删除账号信息
+ (void)removeAccount;
@end
