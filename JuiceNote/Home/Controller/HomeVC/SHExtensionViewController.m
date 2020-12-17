//
//  SHExtensionViewController.m
//  Happiness
//
//  Created by xIang on 16/3/19.
//  Copyright © 2016年 Cheney. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SHExtensionViewController.h"
#import "SHExtensionCollectionViewCell.h"
#import "SHExtensionView.h"
#import "SHAuntViewController.h"
#import "SHAlbumViewController.h"
#import "SHMemorialTableViewController.h"
#import "SHDiaryTableViewController.h"
#import "SHSleepViewController.h"
#import "XJJAccountTool.h"
#import <MJExtension.h>


#define kWAndH ([UIScreen mainScreen].bounds.size.width - 40) / 3


@interface SHExtensionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate>
@property(nonatomic, strong)NSArray *picArray;
@property(nonatomic, strong)NSArray *picTitleArr;
@property (nonatomic, strong)CLLocationManager *locationManager;
@end

@implementation SHExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建对象
    //1.1先创建UICollectionViewFlowLayout对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //1.2配置UICollectionViewFlowLayout的相关属性
    //行间距
    flowLayout.minimumLineSpacing = 10;
    
    //列间距
//    flowLayout.minimumInteritemSpacing = 10;
    //每个item的大小
    flowLayout.itemSize = CGSizeMake(kWAndH, kWAndH);
    //设置距屏幕边缘的距离
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    //滚动方向(默认上下滚动)
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //1.3实例化UICollectionViewFlowLayout并设置flowLayout
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kScreenH/2.5 - 64 - 49) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    //2.配置属性
    
    //3.添加到父视图
    [self.view addSubview:self.collectionView];
    
    //设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[SHExtensionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.picArray = @[@"extension-wake-icon",@"extension-distance-icon",@"extension-menses-icon",@"extension-album-icon",@"extension-anniversary-icon",@"extension-todo-icon"];
    self.picTitleArr = @[@"我睡了",@"账本",@"小姨妈",@"私密相册",@"纪念日",@"记事本"];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHExtensionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *picName = self.picArray[indexPath.row];
    NSString *picTitle = self.picTitleArr[indexPath.row];
    //获取账户信息
    XJJAccount *account = [XJJAccountTool account];
    if (indexPath.row == 0) {
        if ([account.isSleep isEqualToString:@"YES"]) {
            cell.extensionView.imageView.image = [UIImage imageNamed:@"extension-sleeping-icon"];
            cell.extensionView.label.text = @"正在睡觉";
            return cell;
        }
    }
    cell.extensionView.imageView.image = [UIImage imageNamed:picName];
    cell.extensionView.label.text = picTitle;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    //获取账户信息
    XJJAccount *account = [XJJAccountTool account];
    
    if (indexPath.row == 0) {//我睡了
        if ([account.isSleep isEqualToString:@"YES"]) {
            SHSleepViewController *sleepVC = [[SHSleepViewController alloc] init];
            sleepVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:sleepVC animated:YES completion:nil];
        }else{
        //添加事件
        //我睡了
        UIAlertAction *actionSleep = [UIAlertAction actionWithTitle:@"我睡了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            SHExtensionCollectionViewCell *cell = (SHExtensionCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.extensionView.imageView.image = [UIImage imageNamed:@"extension-sleeping-icon"];
            cell.extensionView.label.text = @"正在睡觉";
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
            //设置日期格式(声明字符串里面每个数字和单词的含义)
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            account.sleepTimeDate = [fmt stringFromDate:[NSDate date]];
            account.isSleep = @"YES";
            //存入沙盒
            [XJJAccountTool saveAccount:account];
        }];
        [alertVC addAction:actionSleep];
            
        //取消
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            
        }];
        [alertVC addAction:actionCancel];
        // 模态显示
        [self presentViewController:alertVC animated:YES completion:nil];
        }
    } else if (indexPath.row == 1){//发送距离
        
        
    } else if (indexPath.row == 2){//小姨妈
        SHAuntViewController *auntVC = [[SHAuntViewController alloc] init];
        [self.navigationController pushViewController:auntVC animated:YES];
    } else if (indexPath.row == 3){
        SHAlbumViewController *albumVC = [[SHAlbumViewController alloc] init];
        [self.navigationController pushViewController:albumVC animated:YES];
    } else if (indexPath.row == 4){
        SHMemorialTableViewController *memorialTVC = [[SHMemorialTableViewController alloc] init];
        [self.navigationController pushViewController:memorialTVC animated:YES];
    } else if (indexPath.row == 5){
        SHDiaryTableViewController *diaryTVC = [[SHDiaryTableViewController alloc] init];
        [self.navigationController pushViewController:diaryTVC animated:YES];
    }
}
\


@end
