

#import <Foundation/Foundation.h>

@interface XJJUtilityTool : NSObject
//获取转换后的相对时间
+ (NSString *)getCompareDate:(NSDate *)theDate;

/**
 * 开始到结束的时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;


//检查string是否有值
+ (BOOL)hasStringValue:(NSString *)value;

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg;

//时间str转换格式
+ (NSString *)changeFormatWithDateString:(NSString *)dateString fromDateFormat:(NSString *)fromDateFormat toDateFormat:(NSString *)toDateFormat;

//时间转str
+ (NSString *)getDateStrWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

//str转时间
+ (NSDate *)getDateWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat;

//时间转UTC格式str
+ (NSString *)stringFromdateUTC:(NSDate *)date;

/**根据周次获取周次的范围日期*/
+(NSDictionary *)timeConversionYear:(NSInteger)year WeakOfYear:(NSInteger)weekofYear;

+ (NSString *)toJSONString:(id)theData;
+ (id) toJSONObject:(NSString *)jsonString;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//图像压缩
+ (NSData *)normalResImageForAsset:( UIImage*)pickerimage;

+ (BOOL)isNetworkReachable;

//MD5加密
+ (NSString *)md5:(NSString *)input;

//SHA256加密
+ (NSString *)SHA256WithStr:(NSString *)str;

//数字每隔3位加一个逗号
+(NSString *)countNumAndChangeformat:(NSString *)num;


/**
 判断是否为第一次加载或者是更新后第一次加载

 @return YES OR NO
 */
+ (BOOL) isFirstLoad;

// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName;

/**清除缓存和cookie*/
+ (void)cleanCacheAndCookie;

//手机号正则校验
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//邮箱正则校验
+ (BOOL)isEmail:(NSString *)email;

//是数字和字母
+ (BOOL)isNumberAndLetter:(NSString *)str;

//是数字
+ (BOOL)isNumber:(NSString *)number;

//利用下面这个方法hasEmoji可以限制第三方键盘（常用的是搜狗键盘）的表情
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string;

//利用下面这个方法stringContainsEmoji可以限制系统键盘自带的表情
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

//利用下面这个方法isNineKeyBoard可以判断当前是不是在使用九宫格输入
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+ (BOOL)isNineKeyBoard:(NSString *)string;
@end
