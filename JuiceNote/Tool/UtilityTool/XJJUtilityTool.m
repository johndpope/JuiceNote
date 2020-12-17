

#import "XJJUtilityTool.h"
#import <netinet/in.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"

@interface XJJUtilityTool ()<UIAlertViewDelegate>

@end
@implementation XJJUtilityTool
+ (NSString *)getCompareDate:(NSDate *)theDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeString = [formatter stringFromDate:theDate];
    //如果是今年的，就不要显示年份了
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps1 = [calendar components:unitFlags fromDate:[NSDate date]];
    int currentYear = (int)comps1.year;
    NSDateComponents *comps2 = [calendar components:unitFlags fromDate:theDate];
    int year = (int)comps2.year;
    if(currentYear == year){
        [formatter setDateFormat:@"MM-dd HH:mm"];
        timeString = [formatter stringFromDate:theDate];
    }
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval late=[theDate timeIntervalSince1970]*1;
    
    NSTimeInterval cha=now-late;
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        if([timeString isEqual:@"0"] || cha < 0){
            timeString = @"刚刚";
        }else {
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }else{
        if (cha/3600>1&&cha/86400<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        }else{
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dayString = [formatter stringFromDate:theDate];
            NSDate *day1=[formatter dateFromString:dayString];
            dayString = [formatter stringFromDate:dat];
            NSDate *day2=[formatter dateFromString:dayString];
            now=[day2 timeIntervalSince1970]*1;
            late=[day1 timeIntervalSince1970]*1;
            cha=now-late;
            if(cha/86400<=3){
                if (cha/86400>=1 && cha/86400<=2){
                    [formatter setDateFormat:@"dd"];
                    NSString *day1 = [formatter stringFromDate:theDate];
                    NSString *day2 = [formatter stringFromDate:dat];
                    
                    if ([day2 integerValue] - [day1 integerValue] > 1) {
                        timeString = @"前天";
                    }else{
                        timeString = @"昨天";
                    }
                }
                if(cha/86400>2 && cha/86400<=3){
                    [formatter setDateFormat:@"dd"];
                    NSString *day1 = [formatter stringFromDate:theDate];
                    NSString *day2 = [formatter stringFromDate:dat];
                    
                    if ([day2 integerValue] - [day1 integerValue] > 2) {
                        [formatter setDateFormat:@"MM-dd"];
                        timeString = [formatter stringFromDate:theDate];
                    }else{
                        timeString = @"前天";
                    }

                }
                [formatter setDateFormat:@"HH:mm"];
                NSString *hm=[formatter stringFromDate:theDate];
                timeString = [timeString stringByAppendingString:@" "];
                timeString = [timeString stringByAppendingString:hm];
            }
        }
    }
    return timeString;
}

/**
 * 开始到结束的时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"处理%d天%d小时",day,house];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"处理%d小时%d分",house,minute];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"处理%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"处理%d秒",second];
    }
    return str;
}


+ (BOOL)hasStringValue:(NSString *)value{
    if(value != nil && ![value isKindOfClass:[NSNull class]] && ![value isEqual:@""]){
        return YES;
    }
    return NO;
}

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//时间str转换格式
+ (NSString *)changeFormatWithDateString:(NSString *)dateString fromDateFormat:(NSString *)fromDateFormat toDateFormat:(NSString *)toDateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:fromDateFormat];
    NSDate *date = [formatter dateFromString:dateString];
    [formatter setDateFormat:toDateFormat];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//时间转str
+ (NSString *)getDateStrWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//str转时间
+ (NSDate *)getDateWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:dateStr];
    return date;
}

//时间转UTC格式str
+ (NSString *)stringFromdateUTC:(NSDate *)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    // 设置时间格式的时区 东八区 北京时间
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    return [dateFormat stringFromDate:date];
}

/**根据周次获取周次的范围日期*/
+(NSDictionary *)timeConversionYear:(NSInteger)year WeakOfYear:(NSInteger)weekofYear
{
    //周次的范围日期  几月几日 - 几月几日
//    NSString *weekDate = @"";
    
    //时间轴 取每一年的六月一号 没有特别的含义
    NSString *timeAxis = [NSString stringWithFormat:@"%ld-06-01 12:00:00",(long)year];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获得了时间轴
    NSDate *date = [dateFormatter dateFromString:timeAxis];
    
    //日历类 提供大部分的时间计算接口
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**这两个参数的设置影响着周次的个数和划分*****************/
    [calendar setFirstWeekday:2]; //设置每周的开始是星期一
    [calendar setMinimumDaysInFirstWeek:1]; //设置一周至少需要几天
    /****************/
    //一个封装了具体年月日、时秒分、周、季度等的类
    NSDateComponents *comps = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                          fromDate:date];
    
    //时间轴是当前年的第几周
    NSInteger todayIsWeek = [comps weekOfYear];
    //第几周的字符串格式
    //    NSString *todayIsWeekStr = [NSString stringWithFormat:@"%ld",(long)todayIsWeek];
    
    //获取时间轴是星期几 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger todayIsWeekDay = [comps weekday];
    
    //得到时间轴是几号
    //    NSInteger todayIsDay = [comps day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    //firstDiff 星期一相差天数 、 lastDiff 星期天相差天数
    long firstDiff,lastDiff;
    if (todayIsWeekDay == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else
    {
        firstDiff = [calendar firstWeekday] - todayIsWeekDay;
        lastDiff = 8 - todayIsWeekDay;
    }
    
    NSDate *firstDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*firstDiff sinceDate:date];
    NSDate *lastDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*lastDiff sinceDate:date];
    
    long weekdifference = weekofYear - todayIsWeek;
    
    firstDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*7*weekdifference sinceDate:firstDayOfWeek];
    lastDayOfWeek= [NSDate dateWithTimeInterval:24*60*60*7*weekdifference sinceDate:lastDayOfWeek];
    //    NSLog(@"星期一的日期 %@",[dateFormatter stringFromDate:firstDayOfWeek]);
    //    NSLog(@"星期天的日期 %@",[dateFormatter stringFromDate:lastDayOfWeek]);
    
    NSDateComponents *firstDayOfWeekcomps = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                        fromDate:firstDayOfWeek];
    NSDateComponents *lastDayOfWeekcomps = [calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                       fromDate:lastDayOfWeek];
    
    NSInteger startMonth = [firstDayOfWeekcomps month];
    NSInteger startDay = [firstDayOfWeekcomps day];
    
    NSInteger endmonth = [lastDayOfWeekcomps month];
    NSInteger endday = [lastDayOfWeekcomps day];
    
    //    weekDate = [NSString stringWithFormat:@"%ld/%ld-%ld/%ld",(long)startMonth,(long)startDay,(long)endmonth,(long)endday];
    NSDictionary *dic = @{
                          @"startMonth" : @((long)startMonth),
                          @"startDay" : @((long)startDay),
                          @"endmonth" : @((long)endmonth),
                          @"endday" : @((long)endday)
                          };
    return dic;
}


+ (NSString *)toJSONString:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if([jsonData isEqual:[NSNull null]]){
        return @"";
    }
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        return jsonString;
    }else{
        return nil;
    }
}

+ (id) toJSONObject:(NSString *)jsonString{
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


//图像压缩
+ (NSData *)normalResImageForAsset:( UIImage*)pickerimage
{
    // Convert ALAsset to UIImage
    UIImage *image = pickerimage;
    //    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    // Determine output size
    CGFloat maxSize = 1024.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    NSData *imageData=UIImageJPEGRepresentation(newImage, 1.0);
    if (imageData.length>100*1024) {
        if (imageData.length>1024*1024) {//1M以及以上
            imageData=UIImageJPEGRepresentation(newImage, 0.1);
        }else if (imageData.length>512*1024) {//0.5M-1M
            imageData=UIImageJPEGRepresentation(newImage, 0.3);
        }else if (imageData.length>200*1024) {//0.25M-0.5M
            imageData=UIImageJPEGRepresentation(newImage, 0.7);
        }
    }
    
    return imageData;
}

+(BOOL)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

//MD5加密
+ (NSString *)md5:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

//SHA256加密
+ (NSString *)SHA256WithStr:(NSString *)str
{
    const char *s = [str cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}


//数字每隔3位加一个逗号
+ (NSString *)countNumAndChangeformat:(NSString *)num
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:num.doubleValue]];
    return formattedNumberString;
}


#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"
+ (BOOL) isFirstLoad {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults synchronize];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        [defaults synchronize];
        return YES;  
    }  
    return NO;  
}

// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

/**清除缓存和cookie*/
+ (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    //手机号以13,14,15,17,18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9])\\d{8}$";
    NSString *phoneRegex = @"^1[3456789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}

//邮箱正则校验
+ (BOOL)isEmail:(NSString *)email{
    NSString *emailRegex = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

//是数字和字母
+ (BOOL)isNumberAndLetter:(NSString *)str{
    NSString *strRegex = @"[0-9a-zA-Z]*";
    NSPredicate *strTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strRegex];
    return [strTest evaluateWithObject:str];
}

//是数字
+ (BOOL)isNumber:(NSString *)number{
    NSString *numberRegex = @"[0-9]*";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberTest evaluateWithObject:number];
}

//利用下面这个方法stringContainsEmoji可以限制系统键盘自带的表情
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

//利用下面这个方法hasEmoji可以限制第三方键盘（常用的是搜狗键盘）的表情
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

//利用下面这个方法isNineKeyBoard可以判断当前是不是在使用九宫格输入
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+ (BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

@end
