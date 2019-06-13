//
//  DefineCommonHeader.h
//  Empty
//  这是常用宏的头文件
//  Created by xiaoqi on 2017/8/15.
//  Copyright © 2017年 loveseven. All rights reserved.
//

#ifndef DefineCommonHeader_h
#define DefineCommonHeader_h

#pragma mark -- InterfaceDefine --

#define kBaseUrl @""


#pragma mark -- end --

#pragma mark =============================================

//本地简单数据存储单利
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//轻量级数据存储
#define DATA_CATHE [ITTDataCacheManager sharedManager]
//屏幕宽高
#define UISCREEN            [[UIScreen mainScreen] bounds]
#define SCREEN_HEIGHT       UISCREEN.size.height
#define SCREEN_WIDTH        UISCREEN.size.width
#define kRatio              SCREEN_WIDTH/320

//系统版本判定
#define IOS_VERSION_CODE   [[[UIDevice currentDevice] systemVersion] intValue]

#define IS_IOS7     (IOS_VERSION_CODE >= 7.0 && IOS_VERSION_CODE <= 8.0)

#define IS_IOS8     (IOS_VERSION_CODE >= 8.0 )

#define ISLESS_IOS7 (IOS_VERSION_CODE < 7.0)

//设备型号
#define is35InchScreen() ([UIScreen mainScreen].bounds.size.height == 480)

#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iphone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/// iPhoneX  iPhoneXS  iPhoneXS Max  iPhoneXR 机型判断
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)
#define safeAreaNavBarHeight (iPhoneX?88:64)
#define safeAreaHeight (iPhoneX?34:0)

//颜色设置
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//16进制颜色值
#define RGBFromColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//主题色
#define BaseColor    RGBCOLOR(83, 183, 194)

//字体设置
#define UIFontSize(CGFloat) [UIFont systemFontOfSize:CGFloat]

//图片设置
#define ImageNamed(name) [UIImage imageNamed:name]


#endif /* DefineCommonHeader_h */
