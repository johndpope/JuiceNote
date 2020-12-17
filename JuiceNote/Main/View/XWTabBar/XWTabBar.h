
#import <UIKit/UIKit.h>
#import "XWTabBarButton.h"

@class XWTabBar;


@protocol XWTabBarDelegate <NSObject>

- (void)tabBar:(XWTabBar *)tabBar didClickButton:(NSInteger)index;

@end

@interface XWTabBar : UITabBar

@property (nonatomic, strong) NSArray * GMitems;
@property (nonatomic, weak) id<XWTabBarDelegate> GMdelegate;
@property(nonatomic, strong)UIImage *GMbackgroundImage;
@property (nonatomic, strong) NSMutableArray * buttons;
@property (nonatomic, strong) XWTabBarButton * selectedButton;

@property(strong, nonatomic)UIColor *titleColor;
@property(strong, nonatomic)UIColor *titleColorSelected;
@end
