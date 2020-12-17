

#import "XJJAccountTool.h"
//账号存储路径 沙盒路径
#define XJJAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation XJJAccountTool

//存储账号信息
+ (void)saveAccount:(XJJAccount *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:XJJAccountPath];
}

//返回账号信息
+ (XJJAccount *)account{
    XJJAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:XJJAccountPath];
    return account;
}

//删除账户信息
+ (void)removeAccount{
    [[NSFileManager defaultManager]removeItemAtPath:XJJAccountPath error:nil];
}


@end
