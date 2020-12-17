
#import "XJJForgetPWDView.h"
#import <Masonry.h>
#import "UIImage+XJJImage.h"
#import "XJJUtilityTool.h"
@interface XJJForgetPWDView()
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger num;


@end

@implementation XJJForgetPWDView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.num = 60;
        [self setUpUI];
    }
    
    return self;
    
}


- (void)setUpUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"忘记密码";
    titleLabel.textColor = XJJColorHex(0x333333);
    titleLabel.font = XJJFont(22);
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@38);
        make.top.equalTo(@92);
    }];
    
    UITextField *user = [[UITextField alloc] init];
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.user = user;
    NSMutableAttributedString *userPlaceholderString = [[NSMutableAttributedString alloc] initWithString:@"用户名/手机号/工号" attributes:@{NSForegroundColorAttributeName : XJJColorHex(0xB2B2b2)}];
    user.attributedPlaceholder = userPlaceholderString;
    user.font = XJJFont(16);
    [self addSubview:user];
    
    [user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(44);
        make.right.equalTo(@-38);
        make.height.equalTo(@56);
    }];
    
    UIImageView *line1 = [[UIImageView alloc] init];
    line1.backgroundColor = XJJColorHex(0xDADADA);
    [user addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(user);
        make.height.equalTo(@1);
    }];
    
    UIView *view1 = [[UIView alloc] init];
    [self addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user.mas_bottom);
        make.left.height.right.equalTo(user);
    }];
    
    UITextField *check = [[UITextField alloc] init];
    check.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.check = check;
    [check addTarget:self action:@selector(didCheckNumChange:) forControlEvents:UIControlEventEditingChanged];
    check.keyboardType = UIKeyboardTypeNumberPad;
    NSMutableAttributedString *checkPlaceholderString = [[NSMutableAttributedString alloc] initWithString:@"输入验证码" attributes:@{NSForegroundColorAttributeName : XJJColorHex(0xB2B2B2)}];
    check.attributedPlaceholder = checkPlaceholderString;
    check.font = XJJFont(16);
    [view1 addSubview:check];
    
    UIImageView *line2 = [[UIImageView alloc] init];
    line2.backgroundColor = XJJColorHex(0xDADADA);
    [view1 addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view1);
        make.height.equalTo(@1);
    }];
    
    UIView *view2 = [[UIView alloc] init];
    [self addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom);
        make.left.height.right.equalTo(view1);
    }];
    
    UITextField *pwd = [[UITextField alloc] init];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pwd = pwd;
    pwd.keyboardType = UIKeyboardTypeASCIICapable;
    
    NSMutableAttributedString *pwdPlaceholderString = [[NSMutableAttributedString alloc] initWithString:@"输入新的密码" attributes:@{NSForegroundColorAttributeName : XJJColorHex(0xB2B2B2)}];
    pwd.attributedPlaceholder = pwdPlaceholderString;
    pwd.secureTextEntry = YES;
    pwd.font = XJJFont(16);
    [view2 addSubview:pwd];
    
    UIImageView *line3 = [[UIImageView alloc] init];
    line3.backgroundColor = XJJColorHex(0xDADADA);
    [view2 addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view2);
        make.height.equalTo(@1);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    self.loginBtn = loginBtn;
    [loginBtn setBackgroundImage:[UIImage imageWithStretchableName:@"logBtn"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:XJJFont(20)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset(30);
        make.left.right.equalTo(view2);
        make.height.equalTo(@46);
    }];
    
    UIButton *checkBtn = [[UIButton alloc] init];
    self.checkBtn = checkBtn;
    checkBtn.titleLabel.font = XJJFont(12);
    [checkBtn setTitleColor:XJJColorHex(0xD1C08A) forState:UIControlStateNormal];
    [checkBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"check_no_click"] forState:UIControlStateNormal];
    [checkBtn setTitleColor:XJJColorHex(0x999999) forState:UIControlStateDisabled];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"check_did_click"] forState:UIControlStateDisabled];
    [checkBtn addTarget:self action:@selector(didClickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:checkBtn];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(view1);
        make.size.mas_equalTo(CGSizeMake(102, 30));
    }];
    
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(view1);
        make.right.equalTo(checkBtn.mas_left).offset(-20);
    }];
    
    UIButton *eyeBtn = [[UIButton alloc] init];
    [eyeBtn setImage:[UIImage imageNamed:@"no_see"] forState:UIControlStateNormal];
    [eyeBtn setImage:[UIImage imageNamed:@"can_see"] forState:UIControlStateSelected];
    [eyeBtn addTarget:self action:@selector(didClickEyeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:eyeBtn];
    
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(view2);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [pwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(view2);
        make.right.equalTo(eyeBtn.mas_left).offset(-20);
    }];
    
}

- (void)didClickEyeBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pwd.secureTextEntry = !sender.selected;
}


- (void)didClickCheckBtn:(UIButton *)sender {
    if (![XJJUtilityTool hasStringValue:self.user.text]) {
        [XJJUtilityTool alertWithTitle:@"提示" msg:@"请输入账号"];
        return;
    }
    sender.enabled = NO;
    self.num -- ;
    [self.checkBtn setTitle:[NSString stringWithFormat:@"重新获取(%ldS)",self.num] forState:UIControlStateDisabled];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(didChangeText) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    if (self.didClickCheckBtnBlock) {
        self.didClickCheckBtnBlock();
    }
    
}

- (void)didChangeText {
    self.num --;
    [self.checkBtn setTitle:[NSString stringWithFormat:@"重新获取(%ldS)",self.num] forState:UIControlStateDisabled];
    if (self.num<0) {
        self.num = 60;
        self.checkBtn.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)didCheckNumChange:(UITextField *)sender {
    if (sender.text.length > 4) {
        sender.text = [sender.text substringWithRange:NSMakeRange(0, 4)];
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
@end
