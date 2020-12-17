//
//  CYNavigationController.m
//  SmallLoving
//
//  Created by Cheney on 16/3/19.
//  Copyright © 2016年 Cheney. All rights reserved.
//

#import "CYNavigationController.h"
#import "UIImage+XJJImage.h"

@interface CYNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation CYNavigationController

+ (void)initialize {
    //设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置导航条按钮的文字颜色
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = XJJColorHex(0x666666);
    //设置导航条按钮的文字大小
    dic[NSFontAttributeName] = XJJFont(15);
    [item setTitleTextAttributes:dic forState:(UIControlStateNormal)];
    
    //设置不可用状态
    NSMutableDictionary *disableTextAtts = [NSMutableDictionary dictionary];
    //字体颜色
    disableTextAtts[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.6 alpha:0.7];
    disableTextAtts[NSFontAttributeName] = XJJFont(15);
    [item setTitleTextAttributes:disableTextAtts forState:UIControlStateDisabled];
    
    //设置高亮状态按钮
    [item setTitleTextAttributes:disableTextAtts forState:UIControlStateHighlighted];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置 title 的颜色
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:XJJColorHex(0x333333),NSFontAttributeName:XJJMediumFont(16)}];
    // 设置背景
    [self.navigationBar setBackgroundImage:[UIImage imageWithStretchableName:@"nav-bar-bg"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
