//
//  define.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-5.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#ifndef UWBookExchange_define_h
#define UWBookExchange_define_h

// Compiling for iOS
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // iOS 7.0 supported

    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000 // iOS 7.0 supported and required

    #define IS_IOS_7_0_SYSTEM_AVAILABLE      YES

    #else                                         // iOS 7.0 supported but not required

    #ifndef NSFoundationVersionNumber_iPhoneOS_7_0
        #define NSFoundationVersionNumber_iPhoneOS_7_0 999.00
    #endif

    #define IS_IOS_7_0_SYSTEM_AVAILABLE     (NSFoundationVersionNumber >= NSFoundationVersionNumber_iPhoneOS_7_0)

    #endif

#else                                        // iOS 7.0 not supported

    #define IS_IOS_7_0_SYSTEM_AVAILABLE      NO

#endif


#endif
