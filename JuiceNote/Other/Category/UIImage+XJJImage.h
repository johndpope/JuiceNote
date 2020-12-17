
#import <UIKit/UIKit.h>

@interface UIImage (XJJImage)

/**
 *  通过 imageName 获得一个未渲染的图片
 */
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

/**
 *  通过 imageName 获得一个边角不拉伸的图片
 */
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

/**
 *  设置 image 的颜色
 */
+ (instancetype)imageWithName:(NSString *)imageName imageColor:(UIColor *)imageColor;

//获得一个圆角图片
+ (instancetype)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

//根据View获取一个Image
+ (UIImage *) imageWithView:(UIView *)view;

@end
