
#import "SHHomeViewController.h"
#import "SHHomeScrollView.h"
#import "SHCoverImageView.h"
#import "SHExtensionViewController.h"
#import "XJJAccountTool.h"
#import "SHMemorialModel.h"
#import <UIImageView+WebCache.h>
#import "XJJImageTool.h"
#import "XJJAccountTool.h"
#import "XJJAccount.h"
#import <MJExtension.h>
#import <CoreLocation/CoreLocation.h>
#import <Masonry.h>
#import "CYAlertController.h"

@interface SHHomeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>
@property(nonatomic, strong)SHHomeScrollView *homeScrollView;
@property(nonatomic, assign)CGFloat picHeight;
@property(nonatomic, strong)XJJAccount *account;
@property (nonatomic, strong) NSMutableSet *coverNumSet;
@end

@implementation SHHomeViewController


- (CGFloat)picHeight{
    if (!_picHeight) {
        _picHeight = self.view.height/2.5;
    }
    return _picHeight;
}

- (NSMutableSet *)coverNumSet{
    if (!_coverNumSet) {
        _coverNumSet = [NSMutableSet setWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    }
    return _coverNumSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.homeScrollView = [[SHHomeScrollView alloc] init];
    self.homeScrollView.frame = self.view.bounds;

    [self.view addSubview:self.homeScrollView];

    //[self.homeScrollView.coverImageView.loveTimeBtn addTarget:self action:@selector(loveTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.homeScrollView.coverImageView.cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    SHExtensionViewController *extensionVC = [[SHExtensionViewController alloc] init];
    
    [self addChildViewController:extensionVC];
    [self.homeScrollView.extensionView addSubview:extensionVC.view];
    
    [self setCoverImage];
    
    self.account = [XJJAccountTool account];
}

- (void)setCoverImage{
    //获取账户信息
    XJJAccount *account = [XJJAccountTool account];
    if (account.accountHome.coverImageUrl) {
        [self.homeScrollView.coverImageView sd_setImageWithURL:[NSURL URLWithString:account.accountHome.coverImageUrl] placeholderImage: [UIImage imageNamed:@"default_cover_bg1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }else{
        if (self.coverNumSet.count == 0) {
            [self.coverNumSet addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"]];
        }
        NSString *coverNum = [self.coverNumSet anyObject];
        self.homeScrollView.coverImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"default_cover_bg_%@", coverNum]];
        [self.coverNumSet removeObject:coverNum];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCoverImage];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)loveTimeBtnClick:(UIButton *)loveTimeBtn{
    
}

- (void)cameraBtnClick:(UIButton *)cameraBtn{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"上传合影" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openCamera];
    }];
    
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openAlbum];
    }];
    
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"恢复默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.homeScrollView.coverImageView.image = [UIImage imageNamed:@"default_cover_bg"];
        weakSelf.account.accountHome.coverImageUrl = nil;
        XJJImageModel *imageMode = [XJJImageTool imageModel];
        imageMode.coverImage = nil;
        [XJJImageTool saveImageModel:imageMode];
        
        //存储到沙盒
        XJJAccount *account = [XJJAccountTool account];
        
        [XJJAccountTool saveAccount:account];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:actionCamera];
    [alertVC addAction:actionAlbum];
    [alertVC addAction:actionDefault];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)openCamera{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            //提示相机不可用
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机不可用" preferredStyle:(UIAlertControllerStyleAlert)];
            // 添加事件
            //拍照
            UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
            }];
            [alertVC addAction:actionCamera];
            // 模态显示
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
}

- (void)openAlbum{
    //如果想自己写一个图片选择控制器 得利用AssetsLibrary.framework,利用这个框架获得手机上的所有相册图片
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.navigationBar.barStyle = UIBarStyleBlack;

    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    ipc.delegate = self;
    ipc.editing = YES;
    ipc.allowsEditing = YES;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

// UIImagePickerControllerDelegate
//从控制器选择完图片后就调用(拍照完毕或者选择相册图片完毕)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //info中包含了选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //添加图片到photosView中
    self.homeScrollView.coverImageView.image = image;
    
    //存储图片在本地沙盒中
    XJJImageModel *imageModel = [XJJImageTool imageModel];
    imageModel.coverImage = image;
    XJJAccount *account = [XJJAccountTool account];
    
    //存储到本地
    XJJLog(@"存储封面图片成功");
    [XJJImageTool saveImageModel:imageModel];
    [XJJAccountTool saveAccount:account];
    
}


@end
