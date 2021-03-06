//
//  SHWriteDiaryViewController.m
//  SmallLoving
//
//  Created by xIang on 16/4/1.
//  Copyright © 2016年 Cheney. All rights reserved.
//

#import "SHWriteDiaryViewController.h"
#import "SHDiaryView.h"
#import "SHDiaryModel.h"
#import "XJJAccountTool.h"
#import <MJExtension.h>
#import "UIImage+XJJImage.h"

@interface SHWriteDiaryViewController ()<UITextViewDelegate>
@property(nonatomic, strong)SHDiaryView *diaryView;

@end

@implementation SHWriteDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupContentView];
    [self setNavigationBar];
}

- (void)setupContentView{
    self.diaryView = [[SHDiaryView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
    if (self.contentStr) {
        self.diaryView.contentTextView.text = self.contentStr;
        self.diaryView.timeLabel.text = self.timeStr;
        self.diaryView.contentTextView.editable = NO;
    }else{
        [self.diaryView setupTimeLabel];
    }
    [self.view addSubview:self.diaryView];
    self.diaryView.contentTextView.delegate = self;
    //监听文字改变通知
    [XJJNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.diaryView.contentTextView];
}


//设置导航栏
- (void)setNavigationBar{
    if (!self.contentStr) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(complete)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalName:@"nav-bar-white-more-btn"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)rightItemAction:(UIBarButtonItem *)rightItem{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.diaryView.contentTextView.editable = YES;
        [weakSelf.diaryView.contentTextView becomeFirstResponder];
        weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:weakSelf action:@selector(complete)];
        weakSelf.navigationItem.rightBarButtonItem.enabled = NO;

    }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除确认" message:@"日记被删除后将无法恢复!确认删除?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XJJAccount *account = [XJJAccountTool account];
            NSString *key = [weakSelf.diaryView.timeLabel.text substringToIndex:7];
            NSMutableArray *diaryArr = [NSMutableArray arrayWithArray:account.accountHome.diaryDic[key]];
            if (diaryArr.count == 1) {
                [account.accountHome.diaryDic removeObjectForKey:key];
            }else{
                [diaryArr removeObjectAtIndex:weakSelf.indexRow];
                [account.accountHome.diaryDic setObject:diaryArr forKey:key];
            }
            
            [XJJAccountTool saveAccount:account];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:confirm];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];

    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:confirm];
    [alertVC addAction:delete];
    [self presentViewController:alertVC animated:YES completion:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)complete{
    SHDiaryModel *diaryModel = [[SHDiaryModel alloc] init];
    XJJAccount *account = [XJJAccountTool account];
    diaryModel.timeStr = self.diaryView.timeLabel.text;
    diaryModel.contentStr = self.diaryView.contentTextView.text;
    diaryModel.myUserName = account.userName;
    
    NSDictionary *diaryModelDic = diaryModel.mj_keyValues;
    NSString *key = [self.diaryView.timeLabel.text substringToIndex:7];
    NSMutableArray *diaryArr = [NSMutableArray arrayWithArray:account.accountHome.diaryDic[key]];
    NSMutableDictionary *diaryDic = [NSMutableDictionary dictionaryWithDictionary:account.accountHome.diaryDic];
    if (self.contentStr) {
        [diaryArr replaceObjectAtIndex:self.indexRow withObject:diaryModelDic];
    }else{
        [diaryArr insertObject:diaryModelDic atIndex:0];
    }
    [diaryDic setObject:diaryArr forKey:key];
    account.accountHome.diaryDic = diaryDic;
    
    //上传到云端
    [XJJAccountTool saveAccount:account];
    [self.navigationController popViewControllerAnimated:YES];
}

//实现代理方法 UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)textDidChange{
    if (!self.contentStr) {
        self.navigationItem.rightBarButtonItem.enabled = self.diaryView.contentTextView.hasText;
    }else{
        if ([self.contentStr isEqualToString:self.diaryView.contentTextView.text]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else if (self.diaryView.contentTextView.hasText){
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

- (void)dealloc{
    [XJJNotificationCenter removeObserver:self];
}

@end
