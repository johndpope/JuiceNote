//
//  CYTabBarController.m
//  SmallLoving
//
//  Created by Cheney on 16/3/19.
//  Copyright © 2016年 Cheney. All rights reserved.
//

#import "CYTabBarController.h"
#import "SHHomeViewController.h"
#import "SHSweetTimeViewController.h"
#import "CYNotificationViewController.h"
#import "SHProfileViewController.h"
#import "CYNavigationController.h"

#import "UIImage+XJJImage.h"

@interface CYTabBarController ()<XWTabBarDelegate>

@property (nonatomic, strong) SHHomeViewController * smallLovingVC;
@property (nonatomic, strong) SHSweetTimeViewController * discoverVC;
@property (nonatomic, strong) CYNotificationViewController * notificationVC;
@property (nonatomic, strong) SHProfileViewController * profileVC;
@property (nonatomic, strong) NSMutableArray * items;

@end

@implementation CYTabBarController

+ (void)initialize{
    //获取指定类下面的所有tabBarItem
    UITabBarItem *item = nil;
    if (iOS9) {
        item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    }else{
        item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    }
    
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    //字面量设置字典
    att[NSForegroundColorAttributeName] = XJJColorCreater(120, 176, 197, 1);
    //给文本添加属性
    [item setTitleTextAttributes:att forState:UIControlStateSelected];
}

- (XWTabBar *)wxTabBar{
    if (!_wxTabBar) {
        _wxTabBar = [[XWTabBar alloc] initWithFrame:self.tabBar.bounds];
        _wxTabBar.titleColor = XJJColorHex(0x666666);
        _wxTabBar.titleColorSelected = XJJColorHex(0xA28835);
        [self setValue:_wxTabBar forKey:@"tabBar"];
    }
    return _wxTabBar;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAllChildViewControllers];
    //自定义tabBar
    self.wxTabBar.GMdelegate = self;
    self.wxTabBar.GMbackgroundImage = [UIImage imageWithStretchableName:@"tabbar_background"];
    
    // 传递模型
    self.wxTabBar.GMitems = self.items;
}

/**
 *  添加所有的子视图控制器
 */
- (void)addAllChildViewControllers {
    // 创建控制器
    SHHomeViewController * smallLovingVC = [[SHHomeViewController alloc]init];
    _smallLovingVC = smallLovingVC;
    SHSweetTimeViewController * discoverVC = [[SHSweetTimeViewController alloc]init];
    _discoverVC = discoverVC;
    CYNotificationViewController * notificationVC = [[CYNotificationViewController alloc]init];
    _notificationVC = notificationVC;
    SHProfileViewController * profileVC = [[SHProfileViewController alloc]init];
    _profileVC = profileVC;
    // 添加控制器
    [self addOneChildViewController:smallLovingVC image:[UIImage imageWithOriginalName:@"tab-bar-home-icon-normal"] selectedImage:[UIImage imageWithOriginalName:@"tab-bar-home-icon-selected"] title:@"小幸福"];
    [self addOneChildViewController:discoverVC image:[UIImage imageWithOriginalName:@"tab-bar-discovery-icon-normal"] selectedImage:[UIImage imageWithOriginalName:@"tab-bar-discovery-icon-selected"] title:@"发现"];
    [self addOneChildViewController:notificationVC image:[UIImage imageWithOriginalName:@"tab-bar-notification-icon-normal"] selectedImage:[UIImage imageWithOriginalName:@"tab-bar-notification-icon-selected"] title:@"通知"];
    [self addOneChildViewController:profileVC image:[UIImage imageWithOriginalName:@"tab-bar-profile-icon-normal"] selectedImage:[UIImage imageWithOriginalName:@"tab-bar-profile-icon-selected"] title:@"我"];
}

/**
 *  添加一个子视图控制器
 */
- (void)addOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    CYNavigationController * naVC = [[CYNavigationController alloc]initWithRootViewController:viewController];
    viewController.title = title;
    naVC.tabBarItem.title = title;
    naVC.tabBarItem.image = image;
    naVC.tabBarItem.selectedImage = selectedImage;
    [self addChildViewController:naVC];
}

//实现代理方法
- (void)tabBar:(XWTabBar *)tabBar didClickButton:(NSInteger)index{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
