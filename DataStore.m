//
//  DataStore.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "DataStore.h"

@implementation bookImgInfo

-(id)init{
    self = [super init];
    if (self) {
        _comments = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation bookComment


@end

@implementation DataStore
static DataStore* instance = nil;
+(DataStore *)sharedInstance{
    @synchronized(self){
        if (instance == nil) {
            instance = [[DataStore alloc] init];
        }
    }
    return instance;
}

-(id)init{
    self = [super init];
    if (self) {
        _fbFriends = [[NSMutableDictionary alloc] init];
        _bookImgs = [[NSMutableArray alloc] init];
        _bookMaps = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)reset{
    [_fbFriends removeAllObjects];
    [_bookImgs removeAllObjects];
    [_bookMaps removeAllObjects];
}

@end
