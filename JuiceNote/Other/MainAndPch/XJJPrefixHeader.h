//
//  XJJPrefixHeader.h
//  JuiceNote
//
//  Created by xIang on 2020/4/22.
//  Copyright © 2020 xIang. All rights reserved.
//

#ifndef XJJPrefixHeader_h
#define XJJPrefixHeader_h

#import "UIView+XJJFrame.h"
#import <Masonry.h>

/**
 *  自定义调试打印
 */
#ifdef DEBUG
# define XJJLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define XJJLog(...);
#endif

#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)

#define kDevice_Is_iPhoneX (@available(iOS 11.0, *) && ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0)?YES:NO)

#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width
//状态栏高度
#define kStatusBarH (IS_iPhoneX ? 44.f : 20.f)
#define kNavAndStatusBarH (44.f + kStatusBarH)
#define kTabBarH (kDevice_Is_iPhoneX ? (49.f+34.f) : 49.f)
//安全区域高度
#define TabbarSafeBottomMargin (IS_iPhoneX ? 34.f : 0.f)
#define kScale [UIScreen mainScreen].bounds.size.width / 375.0  //设备相对比例
//统一cell线条颜色
#define kXJJSeparatorColor [UIColor colorWithRed:209 / 255.0 green:192 / 255.0 blue:138 / 255.0 alpha:0.7]

//统一字体
#define XJJFont(value) [UIFont systemFontOfSize:ceil(value)]
#define XJJMediumFont(value) iOS9 ? [UIFont fontWithName:@"PingFangSC-Medium" size:ceil(value)] : XJJFont(value)

/**
 *  自定义 RGB 值
 */
#define XJJColorCreater(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
//自定义16进制颜色值
#define XJJColorHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

#define XJJColorHexAlpha(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:a]

// 随机色
#define XJJRandomColor WXColorCreater(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0)

//通知中心
#define XJJNotificationCenter [NSNotificationCenter defaultCenter]

#endif /* XJJPrefixHeader_h */
