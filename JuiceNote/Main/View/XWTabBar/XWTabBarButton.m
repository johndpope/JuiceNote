#import "XWTabBarButton.h"
#import "XWBadgeView.h"

#define XWImageRidio 0.7

@interface XWTabBarButton ()

@property (nonatomic, strong) XWBadgeView * badgeView;

@end

@implementation XWTabBarButton

// 重写 setHighlighted 来取消高亮做的事情
- (void)setHighlighted:(BOOL)highlighted {}

- (XWBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [XWBadgeView buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:_badgeView];
    }
    return _badgeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置文字字体
        self.titleLabel.font = XJJFont(11);
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self setTitleColor:self.titleColor forState:(UIControlStateNormal)];
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected{
    _titleColorSelected = titleColorSelected;
    [self setTitleColor:self.titleColorSelected forState:(UIControlStateSelected)];
}

- (void)setItem:(UITabBarItem *)item {
    _item = item;
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setTitle:_item.title forState:UIControlStateNormal];
    
    [self setImage:_item.image forState:UIControlStateNormal];
    
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    
    // 设置 badgeValue
    self.badgeView.badgeValue = _item.badgeValue;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 1.imageView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.width;
    CGFloat imageH = self.height * XWImageRidio;
    if (!_item.title) {
        imageH = self.height;
//        imageY = - 53;
//        imageH = self.height + 53;
    }
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    // 2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageH - 10;
    CGFloat titleW = self.width;
    CGFloat titleH = self.height - titleY;

    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    // 3.badgeView
    self.badgeView.x = self.width - self.badgeView.width - 10;
    self.badgeView.y = 5;
    
}

// 重写setTitle方法，扩展计算尺寸功能
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}

- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
}


@end
