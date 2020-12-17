
#import "XJJBaseViewController.h"
#import "XJJBackButton.h"
#import "UIImage+XJJImage.h"
#import <FLAnimatedImageView+WebCache.h>
#import "XJJLoadImageView.h"

@interface XJJBaseViewController ()

@end

@implementation XJJBaseViewController

- (instancetype)init{
    XJJBaseViewController *vc = [super init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.navigationController.childViewControllers.count > 1) {
//        WXBackButton *leftBarBtn = [[WXBackButton alloc] init];
//        [leftBarBtn addTarget:self action:@selector(leftBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalName:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction:)];
    }
}

#pragma mark - btnAction
//设置左侧itemAction
- (void)leftBarItemAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (MBProgressHUD *)buildHUD: (NSString *)labelText toShow:(BOOL)toShow{
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    //[self.navigationController.view addSubview:HUD];
//    [self.view addSubview:HUD];
//    HUD.label.text = labelText;
//    if(toShow)[HUD showAnimated:YES];
//    return HUD;
    
    XJJLoadImageView *imgView = [XJJLoadImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    NSString  *filePath = [[NSBundle mainBundle] pathForResource:@"loadingGIF" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];

    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = imgView;
    HUD.label.text = labelText;
    HUD.backgroundView.backgroundColor = [UIColor clearColor];
//     XJJLog(@"%@",HUD.subviews);
    return HUD;
}

- (MBProgressHUD *)buildHUD:(NSString *)labelText toShow:(BOOL)toShow onView:(UIView *)view {
    XJJLoadImageView *imgView = [XJJLoadImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    NSString  *filePath = [[NSBundle mainBundle] pathForResource:@"loadingGIF" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = imgView;
    HUD.label.text = labelText;
    HUD.backgroundView.backgroundColor = [UIColor clearColor];
    //     XJJLog(@"%@",HUD.subviews);
    return HUD;
}

- (void)buildCompleteHUD:(NSString *)labelText imageName:(NSString *)imageName toView:(UIView *)view{
   
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    HUD.customView = imageView;
    HUD.label.text = labelText;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hideAnimated:YES afterDelay:1.5];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
