//
//  SHCoverImageView.m
//  Happiness
//
//  Created by xIang on 16/3/18.
//  Copyright © 2016年 Cheney. All rights reserved.
//

#import "SHCoverImageView.h"
#import "XJJBaseButton.h"

@implementation SHCoverImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self allViews];
    }
    return self;
}

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[XJJBaseButton alloc] init];
        [self addSubview:_cameraBtn];
    }
    return _cameraBtn;
}


- (void)allViews{
    //右侧相机相册btn
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-2);
    }];
    [self.cameraBtn setImage:[UIImage imageNamed:@"dashboard-camera-icon"] forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}



@end
