

#import "XWTabBar.h"
#import "XJJUtilityTool.h"

@interface XWTabBar ()

@property (nonatomic, weak) UIButton * plusBtn;

@end

@implementation XWTabBar


- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)setGMbackgroundImage:(UIImage *)GMbackgroundImage{
    _GMbackgroundImage = GMbackgroundImage;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = GMbackgroundImage;
    [self insertSubview:imageView atIndex:0];
}

- (void)setGMitems:(NSArray *)GMitems{
    _GMitems = GMitems;
    for (UITabBarItem * item in _GMitems) {
        XWTabBarButton * btn = [XWTabBarButton buttonWithType:(UIButtonTypeCustom)];
        btn.titleColor = self.titleColor;
        btn.titleColorSelected = self.titleColorSelected;
        btn.item = item;
        btn.tag = self.buttons.count;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        if (btn.tag == 0) {
            [self btnAction:btn];
        }
        [self addSubview:btn];
        [self.buttons addObject:btn];
    }
}

- (void)btnAction:(XWTabBarButton *)sender {
    if (sender.titleLabel.text) {
        _selectedButton.selected = NO;
        sender.selected = YES;
        _selectedButton = sender;
    }
    
    // 通知 tabBarVc 切换控制器
    if ([_GMdelegate respondsToSelector:@selector(tabBar:didClickButton:)]) {
        [_GMdelegate tabBar:self didClickButton:sender.tag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 调整系统 tabBar 的位置
    CGFloat w = self.width;
    CGFloat h = 49;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = w / (self.GMitems.count);
    CGFloat btnH = h;
    int i = 0;
    for (UIView * tabBarBt in self.subviews) {
        if ([tabBarBt isKindOfClass:NSClassFromString(@"XWTabBarButton")]) {
            btnX = btnW * i;
            tabBarBt.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//
//    if (self.hidden) {
//        return [super hitTest:point withEvent:event];
//    }
//    
//    UIView *view = [self viewWithTag:2];
//    NSInteger count = self.GMitems.count;
//    CGFloat width = kScreenW / count;
//    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, width * 2, 0, width * 2));
//    
//    if (CGRectContainsPoint(rect, point)) {
//        return view;
//    }
//    
//    CGPoint center = CGPointMake(kScreenW / 2, 0);
//    
//    CGFloat distance = sqrtf( powf((point.x - center.x), 2) + powf((point.y - center.y), 2) );
//    if (distance <= 49 / 2) {
//        return view;
//    }
//    
//    return [super hitTest:point withEvent:event];
//    
//}

@end
