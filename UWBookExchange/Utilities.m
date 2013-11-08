//
//  Utilities.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-3.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(UIImage *)imageWithContentsOfFile:(NSString *)name{
    static NSBundle *UWBundle = nil;
    static UIScreen *UWScreen = nil;
    if(UWBundle == nil){
        UWBundle = [NSBundle mainBundle];
    }
    if (UWScreen == nil) {
        UWScreen = [UIScreen mainScreen];
    }
    NSString *path = nil;
    if (UWScreen.scale == 1.0) {
        path = [UWBundle pathForResource:name ofType:@"png"];
    }else{
        path = [UWBundle pathForResource:[[NSString alloc] initWithFormat:@"%@@2x",name] ofType:@"png"];
    }
    return [UIImage imageWithContentsOfFile:path];
}

@end
