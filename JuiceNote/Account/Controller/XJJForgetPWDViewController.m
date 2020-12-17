
#import "XJJForgetPWDViewController.h"

#import "XJJForgetPWDView.h"

#import "XJJNetWorkTool.h"

#import <Masonry.h>
@interface XJJForgetPWDViewController (){
    MBProgressHUD *_hud;
}
@property (nonatomic,strong)XJJForgetPWDView *forgetView;
@end

@implementation XJJForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    XJJForgetPWDView *view = [[XJJForgetPWDView alloc] initWithFrame:self.view.bounds];
    self.forgetView = view;
    [self.view addSubview:view];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(2);
        make.top.equalTo(view).offset(20);
        make.width.height.mas_equalTo(50);
    }];
    
    [view.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    view.didClickCheckBtnBlock = ^{
        [self checkBtnAction];
    };
}

- (void)checkBtnAction{
    NSString *account = [self.forgetView.user.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *parameters = @{
                                 @"mobile" : account
                                 };
    XJJNetWorkTool *tool = [XJJNetWorkTool shareNetWorkTool];
    
    [tool sendHttpRequestWithUrl:@"" parameter:parameters Method:kXJJGET successBlock:^(NSDictionary *dicData, BOOL isEmpty) {
        XJJLog(@"%@",dicData);
        if (dicData) {
            NSString *code = [NSString stringWithFormat:@"%@",dicData[@"code"]];
            if (![code isEqualToString:@"1"]) {
                NSString *message = dicData[@"message"];
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[XJJUtilityTool hasStringValue:message] ? message : @"验证码获取失败" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertVC addAction:confirm];
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
    } fail:^(NSError *error) {
//        NSString *string = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
//        XJJLog(@"%@",string);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码获取失败" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:confirm];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
}

- (void)loginBtnAction:(UIButton *)btn{
    NSString *account = [self.forgetView.user.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *checkStr = self.forgetView.check.text;
    NSString *pwd = self.forgetView.pwd.text;
    NSDictionary *parameters = @{
                                 @"mobile" : account,
                                 @"code" : checkStr,
                                 @"newPwd" : pwd
                                 };
    XJJNetWorkTool *tool = [XJJNetWorkTool shareNetWorkTool];
    _hud = [self buildHUD:@"修改中..." toShow:YES];
    [tool sendHttpRequestWithUrl:@"" parameter:parameters Method:kXJJGET successBlock:^(NSDictionary *dicData, BOOL isEmpty) {
        XJJLog(@"%@",dicData);
        [self->_hud removeFromSuperview];
        if (dicData) {
            NSString *code = [NSString stringWithFormat:@"%@",dicData[@"code"]];
            if (![code isEqualToString:@"1"]) {
                NSString *message = dicData[@"message"];
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[XJJUtilityTool hasStringValue:message] ? message : @"密码修改失败" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertVC addAction:confirm];
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }else{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [alertVC addAction:confirm];
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
    } fail:^(NSError *error) {
        [self->_hud removeFromSuperview];
        //        NSString *string = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        //        XJJLog(@"%@",string);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:confirm];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
}

- (void)closeBarItemAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
