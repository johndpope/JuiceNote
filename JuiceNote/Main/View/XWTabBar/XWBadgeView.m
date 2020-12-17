
#import "XWBadgeView.h"

#import "UIImage+XJJImage.h"

#define XWBadgeViewFont [UIFont systemFontOfSize:11]

@implementation XWBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        // 设置背景图片
        [self setBackgroundImage:[UIImage imageWithStretchableName:@"main_badge"] forState:(UIControlStateNormal)];
        // 设置字体大小
        self.titleLabel.font = XWBadgeViewFont;
        [self sizeToFit];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    // 判断 badgeValue 是否有内容
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
    // 取出字符串的 size
//    if (badgeValue.integerValue > 99) {
//        badgeValue = @"99+";
//    }
//    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:XWBadgeViewFont}];
//    [self setTitle:badgeValue forState:(UIControlStateNormal)];
//    self.width = size.width + 10;
    
    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:XWBadgeViewFont}];
    if (size.width > self.width) {
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:(UIControlStateNormal)];
        [self setTitle:nil forState:(UIControlStateNormal)];
        [self setBackgroundImage:nil forState:(UIControlStateNormal)];
    } else {
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:(UIControlStateNormal)];
        [self setTitle:badgeValue forState:(UIControlStateNormal)];
        [self setImage:nil forState:(UIControlStateNormal)];
    }
}


@end

