

#import "XJJLoginView.h"
#import <Masonry.h>
#import "UIButton+XJJImageTitleSpacing.h"
#import "XJJAccountTool.h"
#import "UIImage+XJJImage.h"

@interface XJJLoginView ()
@property(strong, nonatomic)UIImageView *logoImageView;
@property(strong, nonatomic)UILabel *titleLabel;
@end

@implementation XJJLoginView

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        [self addSubview:_logoImageView];
    }
    return _logoImageView;
}

- (XJJLoginAccountBar *)accountBar{
    if (!_accountBar) {
        _accountBar = [[XJJLoginAccountBar alloc] init];
        [self addSubview:_accountBar];
    }
    return _accountBar;
}

- (XJJLoginAccountBar *)passwordBar{
    if (!_passwordBar) {
        _passwordBar = [[XJJLoginAccountBar alloc] init];
        [self addSubview:_passwordBar];
    }
    return _passwordBar;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [self addSubview:_loginBtn];
    }
    return _loginBtn;
}

- (UIButton *)forgetBtn{
    if (!_forgetBtn) {
        _forgetBtn = [[UIButton alloc] init];
        [self addSubview:_forgetBtn];
    }
    return _forgetBtn;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self allViews];
    }
    return self;
}

- (void)allViews{
    XJJAccount *account = [XJJAccountTool account];
    
    __weak typeof(self) weakSelf = self;
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(92 * kScale);
        make.left.equalTo(weakSelf).offset(37);
    }];
    self.logoImageView.image = [UIImage imageNamed:@"login_logo"];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(16);
    }];
    self.titleLabel.text = @"欢迎来到移动金螳螂";
    self.titleLabel.textColor = XJJColorHex(0x333333);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22 * kScale];
    
    [self.accountBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(36);
        make.top.equalTo(weakSelf).offset(247 * kScale);
    }];
    self.accountBar.iconImageView.image = [UIImage imageNamed:@"account"];
    
    NSMutableAttributedString *accountPlaceholderString = [[NSMutableAttributedString alloc] initWithString:@"账号／手机号／工号" attributes:@{NSForegroundColorAttributeName : XJJColorHex(0xB2B2B2)}];
    self.accountBar.contentTextField.attributedPlaceholder = accountPlaceholderString;
    self.accountBar.contentTextField.autocorrectionType = UITextAutocorrectionTypeNo;

    self.accountBar.contentTextField.text = account.loginName;
    
    [self.passwordBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(36);
        make.top.equalTo(weakSelf.accountBar.mas_bottom).offset(21 * kScale);
    }];
    self.passwordBar.iconImageView.image = [UIImage imageNamed:@"password"];
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName : XJJColorHex(0xB2B2B2)}];
    self.passwordBar.contentTextField.attributedPlaceholder = placeholderString;
    self.passwordBar.contentTextField.secureTextEntry = YES;
    self.passwordBar.contentTextField.text = account.pwd;

    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.passwordBar.lineView.mas_bottom).offset(30 * kScale);
        make.width.mas_equalTo(300 * kScale);
    }];
    [self.loginBtn setBackgroundImage:[UIImage imageWithStretchableName:@"logBtn"] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登   录" forState:UIControlStateNormal];
    
    [self.loginBtn.titleLabel setFont:XJJFont(20)];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-50);
        make.centerX.equalTo(weakSelf);
    }];
    [self.forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:XJJColorHex(0x999999) forState:UIControlStateNormal];
    [self.forgetBtn addTarget:self action:@selector(didClickForgotBtn) forControlEvents:UIControlEventTouchUpInside];
    self.forgetBtn.titleLabel.font = XJJFont(16);
}

- (void)didClickForgotBtn {
    if (self.didClikForgetBtnBlock) {
        self.didClikForgetBtnBlock();
    }
}


@end
