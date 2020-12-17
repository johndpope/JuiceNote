
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "XJJUtilityTool.h"

@interface XJJBaseViewController : UIViewController
- (MBProgressHUD *)buildHUD:(NSString *)labelText toShow:(BOOL)toShow;
- (void)buildCompleteHUD:(NSString *)labelText imageName:(NSString *)imageName toView:(UIView *)view;
- (MBProgressHUD *)buildHUD:(NSString *)labelText toShow:(BOOL)toShow onView:(UIView *)view;
@end
