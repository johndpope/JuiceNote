//
//  XJJNewFeatureViewController.m
//  JuiceNote
//
//  Created by xIang on 2020/4/22.
//  Copyright © 2020 xIang. All rights reserved.
//

#import "XJJNewFeatureViewController.h"
#import "UIWindow+XJJSwitchRVC.h"
#import "UIPageControl+XJJSpace.h"

#define XJJNewFeatureCount 3

@interface XJJNewFeatureViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIPageControl *pageControl;

@end

@implementation XJJNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建一个scrollView:显示所有新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    CGFloat scrollViewW = scrollView.width;
    CGFloat scrollViewH = scrollView.height;
    //如果想要某个方向上不能滚动,那么这个方向对应的尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(XJJNewFeatureCount * scrollViewW, 0);
    //去除弹簧效果
    scrollView.bounces = NO;
    //开启分页滚动
    scrollView.pagingEnabled = YES;
    //去除滚轴
    scrollView.showsHorizontalScrollIndicator = NO;
    //设置代理
    scrollView.delegate = self;
    //2.添加图片到scrollView中
    for (int i = 0; i < XJJNewFeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH)];
        if (kDevice_Is_iPhoneX) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d_x",i+1]];
        }else{
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d",i+1]];
        }
        
        [scrollView addSubview:imageView];
        
        //如果是最后一个imageView 就往里面添加其他内容
        if (i == XJJNewFeatureCount - 1) {
            [self setUpLastImageView:imageView];
        }
    }
    [self.view addSubview:scrollView];
    
    if (XJJNewFeatureCount != 1) {
        //添加pageControl 分页,展示目前看的第几页
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = XJJNewFeatureCount;
        //UIPageControl 就算尺寸为0,内部还是可以显示,不可点击
//            pageControl.width = 100;
//            pageControl.height = 50;
//            pageControl.userInteractionEnabled = NO;
        pageControl.centerX = scrollViewW * 0.5;
        pageControl.centerY = kScreenH - 30 * kScale - 2.5;
        pageControl.XJJ_pageControl_space = @"15";
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
//        [pageControl setValue:[UIImage imageNamed:@"new_feature_pageControl"] forKeyPath:@"pageImage"];
//        [pageControl setValue:[UIImage imageNamed:@"new_feature_pageControl_selected"] forKeyPath:@"currentPageImage"];
        [self.view addSubview:pageControl];
        self.pageControl = pageControl;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double page = scrollView.contentOffset.x / scrollView.width;
    //四舍五入
    self.pageControl.currentPage = (int)(page + 0.5);
    if (self.pageControl.currentPage == XJJNewFeatureCount - 1) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
}

- (void)setUpLastImageView:(UIImageView *)imageView{
    //开启交互功能
    imageView.userInteractionEnabled = YES;
    //1.分享给大家(checkbox)
    /*
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    shareBtn.width = 120;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.7;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    */
    
    //2.开始
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setImage:[UIImage imageNamed:@"new_feature_button"] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"new_feature_button_highlighted"] forState:UIControlStateSelected];
    startBtn.size = startBtn.currentImage.size;
    startBtn.centerX = self.view.centerX;
    startBtn.y = kScreenH - 30 * kScale - 40;
    [imageView addSubview:startBtn];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)shareClick:(UIButton *)shareBtn{
    //状态取反
    shareBtn.selected = !shareBtn.isSelected;
}

- (void)startClick{
    //切换到主控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window switchRootViewController];
}


@end
