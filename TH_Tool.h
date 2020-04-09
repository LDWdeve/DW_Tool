//
//  TH_Tool.h
//  THProject
//
//  Created by mrLiu on 2019/1/2.
//  Copyright © 2019 泰和天润. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MAIN_SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define PAGESIZE @20

#define GET_NOT_NULL_STRING(_str_) ([_str_ isKindOfClass:[NSString class]] ? _str_ : @"")

#define GK_SAVEAREA_TOP                 (GK_IS_iPhoneX ? 24.0f : 0.0f)   // 顶部安全区域
#define GK_SAVEAREA_BTM                 (GK_IS_iPhoneX ? 34.0f : 0.0f)   // 底部安全区域
#define GK_STATUSBAR_HEIGHT             (GK_IS_iPhoneX ? 44.0f : 20.0f)  // 状态栏高度
#define GK_NAVBAR_HEIGHT                44.0f   // 导航栏高度
#define GK_STATUSBAR_NAVBAR_HEIGHT      (GK_STATUSBAR_HEIGHT + GK_NAVBAR_HEIGHT) // 状态栏+导航栏高度
#define GK_TABBAR_HEIGHT                (GK_IS_iPhoneX ? 83.0f : 49.0f)  //tabbar高度

// 判断是否是iPhone X系列
#define GK_IS_iPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "FLBPlatform.h"
//#import "FlutterBoost.h"

typedef NS_ENUM(NSInteger, AlertType) {
    AlertTypeSeeDelete = 0,
    AlertTypeSelecedImage,
    AlertTypeAgainNet,
    AlertTypeAgainSure,
//    AlertTypeSure,
};

typedef NS_ENUM(NSInteger, UIViewBorderLineType) {
    UIViewBorderLineTypeTop,
    UIViewBorderLineTypeRight,
    UIViewBorderLineTypeBottom,
    UIViewBorderLineTypeLeft,
};

NS_ASSUME_NONNULL_BEGIN

@interface TH_Tool : NSObject

+ (NSString *)sendJson:(id)dictionary;
+ (id)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)getHomeStateStr:(int)code;
+ (NSString *)getHomeOrderStateStr:(int)code;
+ (NSString *)getHomeBannerVosStateStr:(int)code;
+ (void)callPhone:(NSString *)phoneStr;
//判断数字是否为空
+ (BOOL)isEmpty:(UITextField *)textField;

+ (NSArray *)optimalGPSPoint:(NSArray *)array;

//获取本地轨迹
+ (NSArray *)optimalGPSPoint:(NSArray *)array withtruckId:(NSString *)truckId;
//计算直线距离
+ (double)lineDistance:(NSDictionary *)firstPointDic withLast:(NSDictionary *)lastPointDic;

+ (void)showHUB:(NSString *)str;
+ (void)hideHUB;

+ (void)showPostAlert:(NSString *)str;

+ (void)showImage:(int)index wihtPhotoArr:(NSArray *)photoArr;

//+ (void)showAlerView:(int(^)(void))hander withTitle:(NSString *)title;

+ (void)showAlerViewTitle:(nullable NSString *)title messageStr:(nullable NSString *)mesStr messageType:(AlertType)alertType  selected:(void (^ __nullable)(int))handler;
/**
 *  date 格式化为string
 *
 *  @param date    待转化的时间
 *  @param formate 转化格式
 *
 *  @return 转化后的字符串
 */
+ (NSString*)stringFromFomate:(NSDate*)date formate:(NSString*)formate;
//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard;
//银行卡判读
+(BOOL)isBankNum:(NSString *)numStr;
//手机号判断
+(BOOL)Isphonenumber:(NSString *)str;
//判断系统版本
+ (BOOL)isiOS11;
//判断系统版本
+ (BOOL)isiOS12;

/// 添加四边阴影效果
+ (void)addShadowToView:(UIView *)theView;

//从上到下渐变
+ (void)addLayer:(UIView *)view;
//从左到右渐变
+ (void)addLandscapeLayer:(UIView *)view withColors:(NSArray *)colors;

//照片加水印
+(UIImage*)addImg:(UIImage *)img Txt:(NSString*)txt;
+ (CGFloat)getNavHeight;
+ (CGFloat)getTabbarHeight;
+ (CGFloat)getTopStateHeight;
+ (CGFloat)getNavViewHeight;
+ (CGFloat)getBottomSafeHeigth;

+ (void)setViewBorder:(UIView *)view color:(UIColor *)color border:(float)border type:(UIViewBorderLineType)borderLineType;
+ (void)setViewBorder:(UIView *)view color:(UIColor *)color radius:(float)radius border:(float)border;
//赋值
+ (NSString *)clearNullStr:(id)str;
//颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (CGRect)relativeFrameForScreenWithView:(UIView *)v;

//导航
+ (void)useMapAppNavigationToLocation:(CLLocation *)destinationLocation;

//银行卡号分隔
+ (NSString *)formatterBankCardNum:(NSString *)string;

@end
//
//@interface DemoRouter : NSObject<FLBPlatform>
//
//    @property (nonatomic,strong) UINavigationController *navigationController;
//
//    //+ (DemoRouter *)sharedRouter;
//
//    @end
//
//
//@implementation DemoRouter
//
//- (void)openPage:(NSString *)name
//          params:(NSDictionary *)params
//        animated:(BOOL)animated
//      completion:(void (^)(BOOL))completion
//    {
//        if([params[@"present"] boolValue]){
//            FLBFlutterViewContainer *vc = FLBFlutterViewContainer.new;
//            [vc setName:name params:params];
//            [self.navigationController presentViewController:vc animated:animated completion:^{}];
//        }else{
//            FLBFlutterViewContainer *vc = FLBFlutterViewContainer.new;
//            [vc setName:name params:params];
//            [self.navigationController pushViewController:vc animated:animated];
//        }
//    }
//
//
//- (void)closePage:(NSString *)uid animated:(BOOL)animated params:(NSDictionary *)params completion:(void (^)(BOOL))completion
//    {
//        FLBFlutterViewContainer *vc = (id)self.navigationController.presentedViewController;
//        if([vc isKindOfClass:FLBFlutterViewContainer.class] && [vc.uniqueIDString isEqual: uid]){
//            [vc dismissViewControllerAnimated:animated completion:^{}];
//        }else{
//            [self.navigationController popViewControllerAnimated:animated];
//        }
//    }
//
//    @end

NS_ASSUME_NONNULL_END
