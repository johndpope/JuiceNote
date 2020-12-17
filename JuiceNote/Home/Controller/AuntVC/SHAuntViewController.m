//
//  SHAuntViewController.m
//  Happiness
//
//  Created by xIang on 16/3/21.
//  Copyright © 2016年 Cheney. All rights reserved.
//

#import "SHAuntViewController.h"
#import "SHSexViewController.h"
#import "SHMenstruationTableViewController.h"
#import "SHAuntIsComing.h"
#import "XJJAccountTool.h"
#import <MJExtension.h>
#import "CYAlertController.h"

@interface SHAuntViewController ()
@property (nonatomic, strong) SHAuntIsComing * auntIsComingView;
@end

@implementation SHAuntViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavigationBar];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
    //设置性别视图
    //获取账户信息
    XJJAccount *account = [XJJAccountTool account];
    if (account.sex == nil) {
        SHSexViewController *sexVC = [[SHSexViewController alloc] init];
        [self.navigationController pushViewController:sexVC animated:YES];
    }
    SHAuntIsComing *auntIsComingView = [[SHAuntIsComing alloc] initWithFrame:self.view.bounds];
    self.auntIsComingView = auntIsComingView;
    [auntIsComingView.womanBtn addTarget:self action:@selector(womanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:auntIsComingView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取账户信息
    XJJAccount *account = [XJJAccountTool account];
    if (account.sex) {
        //设置界面内容
        [self.auntIsComingView setupViewWithAccountHome:account.accountHome];
    }
}



//设置导航栏
- (void)setNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"小姨妈";
    //右键设置
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//女性按钮点击事件
- (void)womanBtnAction:(UIButton *)sender{
    CYAlertController *alertVC = [CYAlertController showAlertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet isSucceed:YES viewController:self];
    CYAlertAction *actionCamera = [CYAlertAction actionWithTitle:@"确认发送" handler:^(UIAlertAction *action) {
        //获取账户信息
        XJJAccount *account = [XJJAccountTool account];
        if ([account.accountHome.isMenstruation isEqualToString:@"YES"]) {
            account.accountHome.isMenstruation = @"NO";
        }else{
            account.accountHome.isMenstruation = @"YES";
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            //设置日期格式(声明字符串里面每个数字和单词的含义)
            fmt.dateFormat = @"yyyy-MM-dd";
            account.accountHome.lastAuntDate = [fmt stringFromDate:[NSDate date]];
        }
        //存储到沙盒
        //上传到云端
        [XJJAccountTool saveAccount:account];

        SHAuntIsComing *auntIsComingView = [[SHAuntIsComing alloc] initWithFrame:self.view.bounds];
        [auntIsComingView.womanBtn addTarget:self action:@selector(womanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.auntIsComingView removeFromSuperview];
        self.auntIsComingView = auntIsComingView;
        [self.view addSubview:auntIsComingView];
        //设置界面内容
        [self.auntIsComingView setupViewWithAccountHome:account.accountHome];
    }];
    alertVC.allActions = @[actionCamera];
}

- (void)rightItemAction:(UIBarButtonItem *)rightItem{
    //获取账户信息
    XJJAccount *account= [XJJAccountTool account];
    if ([account.sex isEqualToString:@"m"]) {
        SHSexViewController *sexVC = [[SHSexViewController alloc] init];
        [self.navigationController pushViewController:sexVC animated:YES];
    }else if ([account.sex isEqualToString:@"f"]) {
        SHMenstruationTableViewController *menstruationTVC = [[SHMenstruationTableViewController alloc] init];
        [self.navigationController pushViewController:menstruationTVC animated:YES];
    }
}

- (void)timeChangeAction{
    //获取账户信息
    XJJAccount *account = [XJJAccountTool account];
    if (([account.accountHome.isMenstruation isEqualToString:@"NO"] || self.auntIsComingView.auntTowelFirstLabel.text) && account.accountHome.lastAuntDate && account.accountHome.interval) {
        [self.auntIsComingView setupAuntTowelSecondLabelWithAccountHome:account.accountHome];
    }
}
@end
