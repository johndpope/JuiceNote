//
//  UIWindow+XJJSwitchRVC.m
//  JuiceNote
//
//  Created by xIang on 2020/4/22.
//  Copyright © 2020 xIang. All rights reserved.
//

#import "UIWindow+XJJSwitchRVC.h"
#import "XJJNewFeatureViewController.h"
#import "XJJLoginViewController.h"

@implementation UIWindow (XJJSwitchRVC)
//切换控制器
- (void)switchRootViewController{
    //设置根控制器
    //上一次使用版本号(存储在沙盒中的版本号)
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleVersion"];
    
    //当前软件的版本号(从info.plist)
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    if ([currentVersion isEqualToString:lastVersion]) {
        //    self.rootViewController = [[GMTabBarController alloc] init];
        self.rootViewController = [[XJJLoginViewController alloc] init];
    }else{
        self.rootViewController = [[XJJNewFeatureViewController alloc] init];
        //将版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleVersion"];
        //马上同步到沙盒中
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
@end
