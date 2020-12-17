//
//  UIPageControl+XJJSpace.m
//  JuiceNote
//
//  Created by xIang on 2020/4/22.
//  Copyright © 2020 xIang. All rights reserved.
//

#import "UIPageControl+XJJSpace.h"
#import <objc/runtime.h>

static const char kSpace;

@implementation UIPageControl (XJJSpace)
- (NSString *)XJJ_pageControl_space {
    return objc_getAssociatedObject(self, &kSpace);
}

- (void)setXJJ_pageControl_space:(NSString *)XJJ_pageControl_space {
    objc_setAssociatedObject(self, &kSpace, XJJ_pageControl_space, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)load
{
    Method origin = class_getInstanceMethod([self class], @selector(_indicatorSpacing));
    Method custom = class_getInstanceMethod([self class], @selector(custom_indicatorSpacing));
    method_exchangeImplementations(origin, custom);
}

- (double)custom_indicatorSpacing
{
    if (self.XJJ_pageControl_space) {
        return self.XJJ_pageControl_space.doubleValue;
    }
    return 15.0;
}
@end
