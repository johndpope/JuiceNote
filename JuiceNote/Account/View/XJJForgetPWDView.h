

#import <UIKit/UIKit.h>

@interface XJJForgetPWDView : UIView
@property(strong, nonatomic)UIButton *loginBtn;

@property (nonatomic,weak) UITextField *user;
@property (nonatomic,weak) UITextField *check;
@property (nonatomic,weak) UITextField *pwd;
@property (nonatomic,weak) UIButton  *checkBtn;

@property(copy, nonatomic) void(^didClickCheckBtnBlock)(void);
@end
