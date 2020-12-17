
#import "XJJBackButton.h"

@implementation XJJBackButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self allViews];
    }
    return self;
}

- (void)allViews{
    [self setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setTitleColor:XJJColorHex(0x262626) forState:UIControlStateNormal];
    self.titleLabel.font = XJJFont(12);
    [self sizeToFit];
    
}

- (void)setSelfWithImageName:(NSString *)imageName title:(NSString *)title{
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [self sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.x = 0;
    self.titleLabel.x = CGRectGetMaxX(self.imageView.frame) + 5;
}


@end
