//
//  XJJLoginViewController.m
//  JuiceNote
//
//  Created by xIang on 2020/4/22.
//  Copyright © 2020 xIang. All rights reserved.
//

#import "XJJLoginViewController.h"
#import "XJJForgetPWDViewController.h"
#import "CYTabBarController.h"
#import <MBProgressHUD.h>
#import "ZYKeyboardUtil.h"
#import "XJJLoginView.h"
#import "XJJAccount.h"
#import "XJJNetWorkTool.h"
#import "XJJAccountTool.h"

@interface XJJLoginViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *_hud;
}

@property(strong, nonatomic)XJJLoginView *loginView;
@property (strong, nonatomic)ZYKeyboardUtil *keyboardUtil;
@property(strong, nonatomic)XJJAccount *account;

@end

@implementation XJJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginView = [[XJJLoginView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:_loginView];
    self.loginView.accountBar.contentTextField.delegate = self;
    self.loginView.passwordBar.contentTextField.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    self.loginView.didClikForgetBtnBlock = ^{
        XJJForgetPWDViewController *vc = [[XJJForgetPWDViewController alloc] init];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
    
    [self.loginView.rememberBtn addTarget:self action:@selector(didClickRemBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginView.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];

    //全自动键盘弹出处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.loginView, nil];
    }];
    
    //自定义键盘收起处理(如不配置，则默认启动自动收起处理)
#pragma explain - if not configure this Block, automatically itself.
    
    [_keyboardUtil setAnimateWhenKeyboardDisappearBlock:^(CGFloat keyboardHeight) {
        //uodateOriginY
        CGFloat newOriginY = 0;
        weakSelf.view.frame = CGRectMake(weakSelf.view.frame.origin.x, newOriginY, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
    }];
    
}


- (void)didClickRemBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (void)loginBtnAction:(UIButton *)btn{
    [self.view endEditing:YES];
    [self gotoContentVC];
    return;
    if (!(self.loginView.accountBar.contentTextField.text && self.loginView.accountBar.contentTextField.text.length > 0) || !(self.loginView.passwordBar.contentTextField.text && self.loginView.passwordBar.contentTextField.text.length > 0) ) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入用户名和密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:action];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        NSDictionary *parameters = @{
                                     @"Account" : [self.loginView.accountBar.contentTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                                     @"Password" : self.loginView.passwordBar.contentTextField.text
                                     };
        _hud = [self buildHUD:@"登录中..." toShow:YES];
        XJJNetWorkTool *tool = [XJJNetWorkTool shareNetWorkTool];
        [tool sendHttpRequestWithUrl:@"" parameter:parameters Method:KXJJPOST successBlock:^(id dicData, BOOL isEmpty) {
            XJJLog(@"%@",dicData);
        } fail:^(NSError *error) {
            [_hud removeFromSuperview];
            XJJLog(@"%@",error);
            
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [vc addAction:action];
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }
}

- (void)gotoContentVC{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[CYTabBarController alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.loginView.accountBar.contentTextField isEditing]) {
        [self.loginView.passwordBar.contentTextField becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}



@end
