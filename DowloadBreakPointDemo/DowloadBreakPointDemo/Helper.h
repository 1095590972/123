//
//  Helper.h
//  DowloadBreakPointDemo
//
//  Created by 郭晓敏 on 15/8/8.
//  Copyright (c) 2015年 com.jiaoxuebu.gxm. All rights reserved.
//

#ifndef DowloadBreakPointDemo_Helper_h
#define DowloadBreakPointDemo_Helper_h
#define kAlertTitle @"蓝鸥科技"

#define K_videoBaseURL @"http://www.aipai.com/api/aipaiApp_action-searchVideo_gameid-25296_keyword-%E8%92%B8%E6%B1%BD%E6%9C%BA%E5%99%A8%E4%BA%BA_op-AND_appver-a2.4.6_page-1.html"
#define CachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define ITAlertView(AlertMessage) [[[UIAlertView alloc] initWithTitle:kAlertTitle message:AlertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

#if defined(DEBUG)
#define ITLog(STRLOG)	 NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG)
//   #define ITLog(STRLOG)	NSLog(@"%@ %@: %@ 行号:%d %@", [NSThread currentThread],self, NSStringFromSelector(_cmd), __LINE__, STRLOG)
//#define ITLog(STRLOG)
//#define ITLog(STRLOG)	if (STRLOG) { NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG); } else { NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));}
#else
#if TARGET_IPHONE_SIMULATOR
// 模拟器中仍然显示日志
//#define ITLog(STRLOG)	NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG)
#define ITLog(STRLOG)
#else
// release版本目前也增加日志吧,正式发部时再决定是否去掉
#define ITLog(STRLOG)
//        #define ITLog(STRLOG)	NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG)
//#define ITLog(STRLOG)
#endif
#endif

#define k_newVideoDidStartDown  @"newVideoDidStartDown"

#define k_videoDidDownedFinishedSuccess @"videoDidDownedSuccess"
#endif
