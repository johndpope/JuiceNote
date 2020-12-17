

#import <UIKit/UIKit.h>
#import "XJJLoginAccountBar.h"

@interface XJJLoginView : UIView
@property(strong, nonatomic)XJJLoginAccountBar *accountBar;
@property(strong, nonatomic)XJJLoginAccountBar *passwordBar;
@property(strong, nonatomic)UIButton *rememberBtn;
@property(strong, nonatomic)UIButton *loginBtn;
@property(strong, nonatomic)UIButton *forgetBtn;
@property (nonatomic,copy) void(^didClikForgetBtnBlock)();
@end
