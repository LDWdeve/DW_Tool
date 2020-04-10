//
//  TH_Tool.m
//  THProject
//
//  Created by mrLiu on 2019/1/2.
//  Copyright © 2019 泰和天润. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "DW_Tool.h"

//#import "TKAlertCenter.h"
//#import "MBProgressHUD.h"
//#import <YBImageBrowser/YBImageBrowser.h>
//#import "HTPasswordShowView.h"
//#import "HTInputPasswordView.h"

//#import <UIKit/UIKit.h>

static NSDateFormatter * _formatter = nil;
@implementation DW_Tool

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


@end
