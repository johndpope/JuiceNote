

#import "XJJImageTool.h"
//图片沙盒路径
#define XJJImageModelPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"imageModel.archive"]

@implementation XJJImageTool
//存储图片类
+ (void)saveImageModel:(XJJImageModel *)imageModel{
    [NSKeyedArchiver archiveRootObject:imageModel toFile:XJJImageModelPath];
}

//返回图片类
+ (XJJImageModel *)imageModel{
    XJJImageModel *imageModel = [NSKeyedUnarchiver unarchiveObjectWithFile:XJJImageModelPath];
    if (!imageModel) {
        imageModel = [[XJJImageModel alloc] init];
    }
    return imageModel;
}

//删除照片类
+ (void)removeImageModel{
    [[NSFileManager defaultManager]removeItemAtPath:XJJImageModelPath error:nil];
}

@end
