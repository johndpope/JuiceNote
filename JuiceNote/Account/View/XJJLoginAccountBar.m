
#import "XJJLoginAccountBar.h"
#import "XJJUtilityTool.h"
#import <Masonry.h>

@implementation XJJLoginAccountBar

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UITextField *)contentTextField{
    if (!_contentTextField) {
        _contentTextField = [[UITextField alloc] init];
        [self addSubview:_contentTextField];
    }
    return _contentTextField;
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
    __weak typeof(self) weakSelf = self;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(41 * kScale);
    }];
    
    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(18 * kScale);
        make.centerY.equalTo(weakSelf.iconImageView);
        make.size.mas_equalTo(CGSizeMake((300 - 20 - 18) * kScale, 20 * kScale));
    }];

    self.contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentTextField.textColor = XJJColorHex(0x333333);
    self.contentTextField.font = XJJFont(16);
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = XJJColorHex(0xDADADA);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(15 * kScale);
        make.size.mas_equalTo(CGSizeMake(300 * kScale, 1));
    }];
    
}


@end
