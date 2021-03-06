//
//  NSOperationQueue+SharedQueue.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "NSOperationQueue+SharedQueue.h"

@implementation NSOperationQueue (SharedQueue)

+(NSOperationQueue *)pffileOperationQueue{
    static NSOperationQueue *pffileQueue = nil;
    if (pffileQueue == nil) {
        pffileQueue = [[NSOperationQueue alloc] init];
        [pffileQueue setName:@"com.uwaterloo.jind"];
    }
    return pffileQueue;
}

+(NSOperationQueue *)profilePictureOperationQueue{
    static NSOperationQueue *profileQueue = nil;
    if (profileQueue == nil) {
        profileQueue = [[NSOperationQueue alloc] init];
        [profileQueue setName:@"com.uwaterloo.jind.profile"];
    }
    return profileQueue;
}

@end
