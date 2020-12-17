

#import <Foundation/Foundation.h>
#import "XJJImageModel.h"

@interface XJJImageTool : NSObject
//存储图片类
+ (void)saveImageModel:(XJJImageModel *)imageModel;

//返回图片类
+ (XJJImageModel *)imageModel;

//删除照片类
+ (void)removeImageModel;

@end
