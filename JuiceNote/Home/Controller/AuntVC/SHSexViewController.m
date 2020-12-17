//
//  SHSexViewController.m
//  Happiness
//
//  Created by xIang on 16/3/23.
//  Copyright © 2016年 Cheney. All rights reserved.
//

#import "SHSexViewController.h"
#import "SHSexView.h"
#import "SHIconView.h"
#import "XJJAccountTool.h"
#import <MJExtension.h>
#import "CYAlertController.h"

@interface SHSexViewController ()
@property (nonatomic, strong) SHSexView * sexView;
@end

@implementation SHSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.sexView = [[SHSexView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.sexView];
    [self.sexView.confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sexView.manIconView.iconBtn addTarget:self action:@selector(manIconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sexView.womanIconView.iconBtn addTarget:self action:@selector(womanIconBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取账户信息
    XJJAccount *cyAccount = [XJJAccountTool account];
    if ([cyAccount.sex isEqualToString:@"f"]) {
        self.sexView.womanIconView.selectedImageView.hidden = NO;
    }else{
        self.sexView.manIconView.selectedImageView.hidden = NO;
    }
    
    
}

//设置导航栏
- (void)setNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"设置";
}

- (void)leftItemAction:(UIBarButtonItem *)leftItem{
    [self.navigationController popViewControllerAnimated:YES];
}


//确定btn点击事件
- (void)confirmBtnAction:(UIButton *)confirmBtn{
    NSString *genderStr = [NSString string];
    if (!self.sexView.manIconView.selectedImageView.hidden) {
        genderStr = @"m";
    }else if (!self.sexView.womanIconView.selectedImageView.hidden){
        genderStr = @"f";
    }

    if ([genderStr isEqualToString:@"m"] || [genderStr isEqualToString:@"f"]) {
        CYAlertController *alertVC = [CYAlertController showAlertControllerWithTitle:@"提示" message:@"性别修改成功" preferredStyle:UIAlertControllerStyleActionSheet isSucceed:YES viewController:self];
        CYAlertAction *actionCamera = [CYAlertAction actionWithTitle:@"确定" handler:^(UIAlertAction *action) {
            //获取账户信息
            XJJAccount *account = [XJJAccountTool account];
            account.sex = genderStr;
            //存储到沙盒
            //上传到云端
            [XJJAccountTool saveAccount:account];
        }];
        alertVC.allActions = @[actionCamera];
    }
}

//选择男性btn点击事件
- (void)manIconBtnAction:(UIButton *)iconBtn{
    self.sexView.manIconView.selectedImageView.hidden = NO;
    self.sexView.womanIconView.selectedImageView.hidden = YES;
}

//选择女性btn点击事
- (void)womanIconBtnAction:(UIButton *)iconBtn{
    self.sexView.manIconView.selectedImageView.hidden = YES;
    self.sexView.womanIconView.selectedImageView.hidden = NO;
}


@end
