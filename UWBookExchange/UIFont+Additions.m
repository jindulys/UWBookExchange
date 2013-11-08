//
//  UIFont+Additions.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-5.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+(UIFont *) UWBESystemFontOfSize:(CGFloat)size;{
    static NSMutableDictionary *fontContainer = nil;
    if (fontContainer == nil) {
        fontContainer = [[NSMutableDictionary alloc] init];
    }
    UIFont *ownFont = [fontContainer objectForKey:[NSNumber numberWithFloat:size]];
    if (ownFont == nil) {
        if (IS_IOS_7_0_SYSTEM_AVAILABLE) {
            ownFont = [UIFont systemFontOfSize:size];
        }else{
            ownFont = [UIFont systemFontOfSize:size];
        }
        [fontContainer setObject:ownFont forKey:[NSNumber numberWithFloat:size]];
        return ownFont;
    }else{
        return ownFont;
    }
}

@end
