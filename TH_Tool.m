//
//  TH_Tool.m
//  THProject
//
//  Created by mrLiu on 2019/1/2.
//  Copyright © 2019 泰和天润. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TH_Tool.h"
#import "THProject-Swift.h"
#import "TKAlertCenter.h"
#import "MBProgressHUD.h"
#import <YBImageBrowser/YBImageBrowser.h>
#import "HTPasswordShowView.h"
#import "HTInputPasswordView.h"

//#import <UIKit/UIKit.h>

static NSDateFormatter * _formatter = nil;
@implementation TH_Tool

//字典封装json
+ (NSString *)sendJson:(id)dictionary
{
    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return str;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)getHomeOrderStateStr:(int)code{
    NSDictionary *dic = @{@100:@"待派单",@110:@"待接单",@120:@"装货中",@130:@"装货确定中",@140:@"装货拒绝",@200:@"运输中",@210:@"到货确认中",@215:@"到货拒绝",@220:@"待结算",@230:@"回执油卡",@300:@"已完成",@400:@"取消"};
     return dic[@(code)];
}

+ (NSString *)getHomeStateStr:(int)code{

     NSDictionary *dic = @{
                             @10:@"未实名认证",
                             @20:@"未司机认证",
                             @30:@"订单信息",
                             @40:@"未签署安心签"
                        };
    return dic[@(code)];
}

+ (NSString *)getHomeBannerVosStateStr:(int)code{

    NSDictionary *dic = @{
                          @10:@"待处理",
                          @20:@"油卡",
                          @30:@"尾款",
                          };
    return dic[@(code)];
}

+ (void)callPhone:(NSString *)phoneStr{

    NSString *str = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

+ (UIViewController *)currentVC{
    AppDelegate *appDeleagte = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UITabBarController *tabBarVC = appDeleagte.tabBarVC;

    UINavigationController *nav = tabBarVC.viewControllers[tabBarVC.selectedIndex];

//    UIViewController *vc = nav.childViewControllers.lastObject;
    return nav;
}
+ (void)showImage:(int)index wihtPhotoArr:(NSArray *)photoArr{

    NSMutableArray *browserDataArr = [NSMutableArray array];
    UIImage *defineImage = [UIImage imageNamed:@"common_photoAdd"];
    for (int i = 0; i < photoArr.count; i ++) {
        id type = photoArr[i];

        if ([type isKindOfClass:[UIImage class]]) {
            if (type != defineImage) {

                YBIBImageData *data1 = [YBIBImageData new];
                data1.image = ^UIImage * _Nullable{
                    return type;
                };
//                data1.imageBlock = ^__kindof UIImage * _Nullable{
//
//                };
//                data1.sourceObject = ...;
                [browserDataArr addObject:data1];
//                YBImageBrowseCellData *data1 = [YBImageBrowseCellData new];
//                data1.imageBlock = ^__kindof UIImage * _Nullable{
//                    return type;
//                };
////                data1.sourceObject = ...;
//                [browserDataArr addObject:data1];
            }

        }else if ([type isKindOfClass:[NSDictionary class]]){

            NSString *urlStr;
            if (type[@"url"]) {
                urlStr = type[@"url"];
            }else {
                urlStr = [NSString stringWithFormat:@"%@%@",type[@"domain"],type[@"key"]];
            }

            YBIBImageData *data = [YBIBImageData new];

            data.imageURL = [NSURL URLWithString:urlStr];
//            data.sourceObject = [self sourceObjAtIdx:idx];
            [browserDataArr addObject:data];

        }else if ([type isKindOfClass:[NSString class]]){

            YBIBImageData *data = [YBIBImageData new];
            if([type containsString:@"http"]){
                data.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",type]];
            }else{
                  data.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[TX_LoginModel getBaseUrl],type]];
            }
            //            data.sourceObject = [self sourceObjAtIdx:idx];
            [browserDataArr addObject:data];
        }
    }

//    [self.dataArray enumerateObjectsUsingBlock:^(NSString *_Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {


//    }];

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    
    browser.currentPage = index;
    [browser show];

}
/*
+ (void)showImage:(int)index wihtPhotoArr:(NSArray *)photoArr{

    NSMutableArray *photos = [NSMutableArray array];
    UIImage *defineImage = [UIImage imageNamed:@"common_photoAdd"];

    for (int i = 0; i < photoArr.count; i ++) {
        id type = photoArr[i];

        if ([type isKindOfClass:[UIImage class]]) {
            if (type != defineImage) {
                IDMPhoto *photo = [[IDMPhoto alloc] initWithImage:type];
                [photos addObject:photo];
            }

        }else if ([type isKindOfClass:[NSDictionary class]]){

            NSString *urlStr;
            if (type[@"url"]) {
                urlStr = type[@"url"];
            }else {
                urlStr = [NSString stringWithFormat:@"%@%@",type[@"domain"],type[@"key"]];
            }
            IDMPhoto *photo = [[IDMPhoto alloc] initWithURL:[NSURL URLWithString:urlStr]];
            [photos addObject:photo];
        }
    }

    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];


    [browser setInitialPageIndex:index];
    browser.displayCounterLabel = YES;
    browser.view.tintColor = [UIColor whiteColor];
    browser.progressTintColor = [UIColor orangeColor];
    //    browser.trackTintColor = [[UIColor alloc] initWithWhite:0.8 alpha:1];
    browser.autoHideInterface = NO;


    [[self currentVC] presentViewController:browser animated:YES completion:nil];
}*/

//判断数字是否为空
+ (BOOL)isEmpty:(UITextField *)textField{

    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (trimmedString.length == 0)
    {
        return YES;
    }

    return NO;
}
#pragma mark - 轨迹优化

+ (void)showHUB:(NSString *)str{

    UIView *view = [UIApplication sharedApplication].keyWindow;

    MBProgressHUD *hubView = [MBProgressHUD showHUDAddedTo:view animated:YES];

    if (str) {
        hubView.label.text = str;
    }
}
+ (void)hideHUB{

    UIView *view = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:view animated:YES];
}
+ (void)showPostAlert:(NSString *)str{

    [[TKAlertCenter defaultCenter] postAlertWithMessage:str];
}

+ (NSArray *)optimalGPSPoint:(NSArray *)array withtruckId:(NSString *)truckId{

    NSArray *pointArr = [TH_Tool optimalGPSPoint:array];

    NSMutableArray *newPointArr = [NSMutableArray arrayWithCapacity:0];

    for (NSDictionary *dic in pointArr) {

        NSArray *idArr = dic[@"truckCarryInfoIds"];

        if ([idArr containsObject:truckId]) {
            [newPointArr addObject:dic];
        }
    }
    return newPointArr;
}

+ (NSArray *)refreshtruckId:(NSArray *)array{
    NSMutableArray *newArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0;i <array.count;i ++) {

        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:[array[i] copy]];
        if (newDic[@"truckCarryInfoId"]) {

            NSString *str = newDic[@"truckCarryInfoId"];
            NSArray *truckCarryInfoIds = [TH_Tool dictionaryWithJsonString:str];
            newDic[@"truckCarryInfoIds"] = truckCarryInfoIds;
            [newDic removeObjectForKey:@"truckCarryInfoId"];
        }

        [newArr addObject:newDic];
    }

    return [newArr copy];
}

+ (double)lineDistance:(NSDictionary *)firstPointDic withLast:(NSDictionary *)lastPointDic{

       CLLocationDegrees firstLat = [firstPointDic[@"latitude"] doubleValue];
       CLLocationDegrees firstLon = [firstPointDic[@"longitude"] doubleValue];
       CLLocationCoordinate2D firstCoordinate = CLLocationCoordinate2DMake(firstLat, firstLon);

       MAMapPoint firstPoint = MAMapPointForCoordinate(firstCoordinate);

       CLLocationDegrees lastLat = [lastPointDic[@"latitude"] doubleValue];
       CLLocationDegrees lastLon = [lastPointDic[@"longitude"] doubleValue];
       CLLocationCoordinate2D lastCoordinate = CLLocationCoordinate2DMake(lastLat,lastLon);
       MAMapPoint lastPoint = MAMapPointForCoordinate(lastCoordinate);

        return MAMetersBetweenMapPoints(firstPoint, lastPoint);

}
+ (NSArray *)optimalGPSPoint:(NSArray *)array
{

    array = [TH_Tool refreshtruckId:array];

    NSUInteger num = array.count;

    NSMutableArray *newPointArr = [NSMutableArray arrayWithCapacity:0];

    NSUInteger changeNum = newPointArr.count;


    //如果第n-1与n+1两点距离小于60抛掉第n个点，但是如果n-2与n+2两个点也小于一个值的时候，表示第n个点是一个折回点，不用抛第n个点，


    while (num != changeNum) {

        NSMutableArray *pointArr = [NSMutableArray arrayWithCapacity:0];
        num = array.count;

        for (int i = 0; i < array.count; i ++)
        {
            NSDictionary *dic = array[i];

            if ([dic[@"latitude"] doubleValue] == 0||[dic[@"longitude"] doubleValue] == 0) {

                [pointArr addObject:@(i)];
            }

            if (i + 2 <= array.count - 1)
            {
                NSDictionary *dicTwo = array[i + 2];

//                CLLocationDegrees firstLat = [dic[@"latitude"] doubleValue];
//                CLLocationDegrees firstLon = [dic[@"longitude"] doubleValue];
//                CLLocationCoordinate2D firstCoordinate = CLLocationCoordinate2DMake(firstLat, firstLon);
//                MAMapPoint firstPoint = MAMapPointForCoordinate(firstCoordinate);
//
//                CLLocationDegrees lastLat = [dicTwo[@"latitude"] doubleValue];
//                CLLocationDegrees lastLon = [dicTwo[@"longitude"] doubleValue];
//                CLLocationCoordinate2D lastCoordinate = CLLocationCoordinate2DMake(lastLat,lastLon);
//                MAMapPoint lastPoint = MAMapPointForCoordinate(lastCoordinate);

//                double distance = MAMetersBetweenMapPoints(firstPoint, lastPoint);
                double distance = [TH_Tool lineDistance:dic withLast:dicTwo];

                if (distance < 60&&(i + 2)!= (array.count - 1))
                {
                    [pointArr addObject:@(i + 1)];
                }
            }

            if (i - 1 >= 0 && i + 3 < array.count - 1)
            {
                NSDictionary *firstDic = array[i - 1];
                NSDictionary *secondDic = array[i + 3];

                CLLocationDegrees firstLat = [firstDic[@"latitude"] doubleValue];
                CLLocationDegrees firstLon = [firstDic[@"longitude"] doubleValue];
                CLLocationCoordinate2D firstCoordinate = CLLocationCoordinate2DMake(firstLat, firstLon);
                MAMapPoint firstPoint = MAMapPointForCoordinate(firstCoordinate);

                CLLocationDegrees lastLat = [secondDic[@"latitude"] doubleValue];
                CLLocationDegrees lastLon = [secondDic[@"longitude"] doubleValue];
                CLLocationCoordinate2D lastCoordinate = CLLocationCoordinate2DMake(lastLat,lastLon);
                MAMapPoint lastPoint = MAMapPointForCoordinate(lastCoordinate);

                double distance = MAMetersBetweenMapPoints(firstPoint, lastPoint);

                if (distance < 80)
                {
                    [pointArr removeObject:@(i + 1)];
                }
            }


        }

        [newPointArr removeAllObjects];

        for (int i = 0; i < array.count; i ++)
        {
            if (![pointArr containsObject:@(i)])
            {

//                NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:[array[i] copy]];
//                if (newDic[@"truckCarryInfoId"]) {
//
//                    NSString *str = newDic[@"truckCarryInfoId"];
//                    NSArray *truckCarryInfoIds = [TH_Tool dictionaryWithJsonString:str];
//                    newDic[@"truckCarryInfoIds"] = truckCarryInfoIds;
//                    [newDic removeObjectForKey:@"truckCarryInfoId"];
//                }

                [newPointArr addObject:array[i]];
            }
        }

        changeNum = newPointArr.count;

        array = [newPointArr copy];
    }

    return newPointArr;
}

+ (void)showAlerViewTitle:(nullable NSString *)title messageStr:(nullable NSString *)mesStr messageType:(AlertType)alertType  selected:(void (^ __nullable)(int))handler{


//: withTitle:(NSString *)title{
    NSString *titleStr = @"提示";
    if (title) {
        titleStr  = title;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:mesStr ?:nil preferredStyle:(AlertTypeAgainNet == alertType || AlertTypeAgainSure == alertType)? UIAlertControllerStyleAlert:UIAlertControllerStyleActionSheet];

    if (alertType == AlertTypeSeeDelete || alertType == AlertTypeSelecedImage) {

    }else{
    NSAttributedString *attriburedTitleStr = [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium],NSForegroundColorAttributeName:UIColorFromRGB(0x404040)}];
    [alert setValue:attriburedTitleStr forKey:@"attributedTitle"];

    NSAttributedString *attriburedStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",mesStr] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:UIColorFromRGB(0x737373)}];
    [alert setValue:attriburedStr forKey:@"attributedMessage"];
    }

    NSArray *seletedArr;
    if (alertType == AlertTypeSeeDelete) {
        seletedArr = @[@"查看照片",@"删除",@"取消"];
    }else if (alertType == AlertTypeAgainNet){
        seletedArr = @[@"取消",@"确定"];
    }else if (alertType == AlertTypeSelecedImage){
        seletedArr = @[@"拍照",@"从相册选择",@"取消"];
    }else if (alertType == AlertTypeAgainSure){
        seletedArr = @[@"确定"];
    }
    for (int i = 0; i < seletedArr.count; i ++) {

        UIAlertActionStyle type = UIAlertActionStyleDefault;
        UIColor *color = UIColorFromRGB(0x404040);

        if ([seletedArr[i] hash] == @"删除".hash) {
            type = UIAlertActionStyleDestructive;
        }else if ([seletedArr[i] hash] == @"取消".hash){
            type = UIAlertActionStyleCancel;
        }else if ([seletedArr[i] hash] == @"确定".hash){
            color = [UIColor orangeColor];

        }

        UIAlertAction *acton = [UIAlertAction actionWithTitle:seletedArr[i] style:type handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                 handler(i);
            }

        }];
        if (alertType == AlertTypeSeeDelete || alertType == AlertTypeSelecedImage) {

        }else{

            [acton setValue:color forKey:@"titleTextColor"];
        }

        [alert addAction:acton];
    }
    [[self currentVC] presentViewController:alert animated:YES completion:nil];
}

+ (NSString*)stringFromFomate:(NSDate*)date formate:(NSString*)formate
{
    if (nil == _formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [_formatter setLocale:enUS];
    }
    [_formatter setDateFormat:formate];
    NSString *str = [_formatter stringFromDate:date];
    return str;
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    //    BOOL flag;
    //    if (identityCard.length <= 0) {
    //        flag = NO;
    //        return flag;
    //    }
    //    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    //    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //    return [identityCardPredicate evaluateWithObject:identityCard];
    int factor[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    NSString *parity[] = {@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"};

    if (identityCard == nil || identityCard.length == 0) {
        return false;
    }

    if (identityCard.length != 18) {
        return false;
    }

    int sum = 0;
    for (int i = 0; i < 17; i++) {
        sum += factor[i] * [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
    }

    int modValue = sum % 11;
    NSString *last = [identityCard substringFromIndex:17];

    if ([[parity[modValue] uppercaseString] isEqualToString:[last uppercaseString]]) {
        return true;
    } else {
        return false;
    }
}

+(BOOL)isBankNum:(NSString *)cardNo
{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];

    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
         NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
          int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
                    if((i % 2) == 0){
                               tmpVal *= 2;
                             if(tmpVal>=10)
                                     tmpVal -= 9;
                          evensum += tmpVal;
                      }else{
                          oddsum += tmpVal;
                       }
             }else{
                        if((i % 2) == 1){
                               tmpVal *= 2;
                               if(tmpVal>=10)
                                         tmpVal -= 9;
                             evensum += tmpVal;
                          }else{
                                    oddsum += tmpVal;
                                 }
                    }
         }

     allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
              return YES;
    else
         return NO;
}


//手机号正则判定
+(BOOL)Isphonenumber:(NSString *)str
{
    if (str.length != 11 || !([[str substringToIndex:2] isEqualToString:@"13"] ||[[str substringToIndex:2] isEqualToString:@"19"]||[[str substringToIndex:2] isEqualToString:@"17"]|| [[str substringToIndex:2] isEqualToString:@"15"] || [[str substringToIndex:2] isEqualToString:@"18"] || [[str substringToIndex:2] isEqualToString:@"14"]  || [[str substringToIndex:2] isEqualToString:@"16"]) || [str rangeOfString:@"^[0-9\\-]*$" options:NSRegularExpressionSearch].location == NSNotFound)
    {

        return NO;
    }
    return YES;

}
//判断系统版本
+ (BOOL)isiOS11{

    int systemVersion = [UIDevice currentDevice].systemVersion.intValue;
    if (systemVersion < 11) {
        return NO;
    }
    return YES;

}

+ (BOOL)isiOS12{

    int systemVersion = [UIDevice currentDevice].systemVersion.intValue;
    if (systemVersion < 12) {
        return NO;
    }
    return YES;
}

/// 添加四边阴影效果
+ (void)addShadowToView:(UIView *)theView{
//    // 阴影颜色
//    theView.layer.shadowColor = [UIColor blackColor].CGColor;
//    // 阴影偏移，默认(0, -3)
//    theView.layer.shadowOffset = CGSizeMake(0,0);
//    // 阴影透明度，默认0
//    theView.layer.shadowOpacity = 0.3;
//    // 阴影半径，默认3
//    theView.layer.shadowRadius = 3;

    theView.backgroundColor = [UIColor whiteColor];
    //v.layer.masksToBounds=YES;这行去掉
    theView.layer.cornerRadius = 8;
    theView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    theView.layer.shadowOffset = CGSizeMake(0, 0);
    theView.layer.shadowOpacity = 0.3;
    theView.layer.shadowRadius = 3;
}
//渐变
+ (void)addLayer:(UIView *)view {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0xff661b).CGColor, (__bridge id)UIColorFromRGB(0xf7f7f7).CGColor];
    gradientLayer.locations = @[@0.4, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
}

//从左到右渐变
+ (void)addLandscapeLayer:(UIView *)view withColors:(NSArray *)colors{

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@0.2, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = view.bounds;
//    for (CAGradientLayer *layer in view.layer.sublayers) {
//         [layer removeFromSuperlayer];
//    }

    [view.layer addSublayer:gradientLayer];
}


+(UIImage*)addImg:(UIImage *)img Txt:(NSString*)txt{
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [[UIColor whiteColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:20];


    NSString *dateStr = [TH_Tool stringFromFomate:[NSDate date] formate:@"yyyy-MM-dd HH:mm:ss"];
    txt = [NSString stringWithFormat:@"%@\n%@",dateStr,txt];

    [txt drawInRect:CGRectMake(20,h - 70, w - 30, 70) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (CGFloat)getNavHeight{
    return GK_STATUSBAR_NAVBAR_HEIGHT;
}
+ (CGFloat)getTabbarHeight{
    return GK_TABBAR_HEIGHT;
}

+ (CGFloat)getTopStateHeight{
    return GK_STATUSBAR_HEIGHT;
}
+ (CGFloat)getNavViewHeight{
    return GK_NAVBAR_HEIGHT;
}
+ (CGFloat)getBottomSafeHeigth{
    return GK_SAVEAREA_BTM;
}
+(void)setViewBorder:(UIView *)view color:(UIColor *)color radius:(float)radius border:(float)border{

    border = 1/[UIScreen mainScreen].scale;
    //设置layer
    CALayer *layer=[view layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:radius];
    //设置边框线的宽
    [layer setBorderWidth:border];
    //设置边框线的颜色
    [layer setBorderColor:[color CGColor]];
}

+(void)setViewBorder:(UIView *)view color:(UIColor *)color border:(float)border type:(UIViewBorderLineType)borderLineType {

    CALayer *lineLayer = [CALayer layer];
    border = 1/[UIScreen mainScreen].scale;
    lineLayer.backgroundColor = color.CGColor;
    switch (borderLineType) {
        case UIViewBorderLineTypeTop:{
            lineLayer.frame = CGRectMake(0, 0, view.frame.size.width, border);
            break;
        }
        case UIViewBorderLineTypeRight:{
            lineLayer.frame = CGRectMake(view.frame.size.width - border, 0, border, view.frame.size.height);
            break;
        }
        case UIViewBorderLineTypeBottom:{
            lineLayer.frame = CGRectMake(0, view.frame.size.height - 1, view.frame.size.width,border);
            break;
        }
        case UIViewBorderLineTypeLeft:{
            lineLayer.frame = CGRectMake(0, 0, border, view.frame.size.height);
            break;
        }

        default:{
            lineLayer.frame = CGRectMake(0, 0, view.frame.size.width-42, border);
            break;
        }
    }

    [view.layer addSublayer:lineLayer];
}
+ (NSString *)clearNullStr:(id)str{
    if([str isKindOfClass:[NSString class]]){
        return str;
    }else if ([str isKindOfClass:[NSNull class]]){
        return @"";
    }else if ([str isKindOfClass:[NSNumber class]]){
        return [str description];
    }
    return @"";
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    if(!v){
        return CGRectMake(0, 0, 0, 0);
    }
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (!iOS7) {
        screenHeight -= 20;
    }
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    while (view.frame.size.width != MAIN_SCREEN_WIDTH || view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}

//导航
+ (void)useMapAppNavigationToLocation:(CLLocation *)destinationLocation {

    if (!destinationLocation)
    {
        return;
    }
    BOOL installedAMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    BOOL installedBaiduMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];

    BOOL qqMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]];

    NSURL * apple_App = [NSURL URLWithString:@"http://maps.apple.com/"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"导航" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if (installedAMap) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

//             NSString *url = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=到拉&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=1&style=2",destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];

             NSString *url = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=WT_Car&lat=%lf&lon=%lf&dev=1&style=0",destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {

            }];
        }];

        [alert addAction:action];
    }
    if (installedBaiduMap) {

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

//            NSString *origin = [NSString stringWithFormat:@"%lf,%lf",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
//            NSString *destination = [NSString stringWithFormat:@"%lf,%lf",destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];


            NSString *url = [NSString stringWithFormat:@"baidumap://map/navi?location=%f,%f&coord_type=gcj02&type=BLK&src=ios.baidu.openAPIdemo",destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {

            }];
        }];

        [alert addAction:action];
    }

    if (qqMap) {

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


            [swiftTool getLocationBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull dic) {


                NSString *url = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%@,%@&tocoord=%f,%f&policy=1",dic[@"latitude"],dic[@"longitude"],destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {

                }];

            }];


        }];

        [alert addAction:action];
    }

    if ([[UIApplication sharedApplication] canOpenURL:apple_App]) {

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


            [swiftTool getLocationBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull dic) {


                NSString *url=[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@,%@&daddr=%f,%f",dic[@"latitude"],dic[@"longitude"],destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {

                }];

            }];


        }];

        [alert addAction:action];
    }

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];

     [alert addAction:action];

      [[self currentVC] presentViewController:alert animated:YES completion:nil];

/*
    if (installedAMap)
    {
        //高德地图导航

//        [[UIApplication sharedApplication] ope]

//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else if (installedBaiduMap)
    {
        //百度地图导航
        NSString *origin = [NSString stringWithFormat:@"%lf,%lf",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
        NSString *destination = [NSString stringWithFormat:@"%lf,%lf",destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];
        NSString *url = [NSString stringWithFormat:@"baidumap://map/direction?origin=%@&destination=%@&mode=driving&coord_type=gcj02&src=WT_Car",origin,destination];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else  if ([[UIApplication sharedApplication] canOpenURL:apple_App]) {

        NSString *urlString=[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,destinationLocation.coordinate.latitude,destinationLocation.coordinate.longitude];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else
    {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有安装地图,现在去安装？" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"安装" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            //跳转到AppStore去安装高德地图
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id461703208?mt=8"]];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:action];
        [alert addAction:cancelAction];

        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;

        [vc presentViewController:alert animated:true completion:nil];

        //        [TX_Tool showPostAlert:"请安装高德"]
        //苹果地图导航
        //        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destinationLocation.coordinate addressDictionary:nil]];
        //        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
        //                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
        //                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];

         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有安装地图,现在去安装？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去安装", nil];
         [alert addBlockHandler:^(NSInteger buttonIndex) {
         if (buttonIndex != 0)
         {
         //跳转到AppStore去安装高德地图
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id461703208?mt=8"]];
         }
         }];
         [alert show];
         */
//    }*/
}

//银行卡号分隔
+ (NSString *)formatterBankCardNum:(NSString *)string

{

    NSString *tempStr=string;

    NSInteger size =(tempStr.length / 4);

    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];

    for (int n = 0;n < size; n++)

    {

        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n*4, 4)]];

    }



    [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size*4, (tempStr.length % 4))]];



    tempStr = [tmpStrArr componentsJoinedByString:@" "];



    return tempStr;
}

@end
