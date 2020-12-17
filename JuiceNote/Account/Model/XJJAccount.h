

#import <Foundation/Foundation.h>
#import "SHAccountHome.h"

@interface XJJAccount : NSObject
@property(copy, nonatomic)NSString *isSleep;
@property(assign, nonatomic)BOOL isExit;

@property(copy, nonatomic)NSString *token;

@property (nonatomic,copy) NSString * loginName;//用户账号
@property (nonatomic,copy) NSString * pwd;//用户密码 public

@property (nonatomic,copy) NSString * userName;//用户名字 public
@property (nonatomic,copy) NSString * phoneNumber;//电话号码
@property (nonatomic, strong) SHAccountHome *accountHome;
@property(nonatomic, strong)NSString *sleepTimeDate;//开始睡觉的时间
@property(nonatomic, strong)NSString *iconURL;
@property(nonatomic, strong)NSString *sex;
@property(nonatomic, strong)NSString *nickName;
@end
