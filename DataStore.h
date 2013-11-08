//
//  DataStore.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bookImgInfo : NSObject

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) id objectId;
@property(nonatomic, strong) NSDictionary<FBGraphUser> *user;
@property(nonatomic, strong) NSDate *createdDate;
@property(nonatomic, strong) NSMutableArray *comments;
@property(nonatomic, strong) NSString *bookName;
@property(nonatomic, strong) NSString *bookPrice;
@property(nonatomic, strong) NSString *bookMajor;

@end

@interface bookComment : NSObject

@property(nonatomic, strong) NSDictionary<FBGraphUser> *user;
@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) NSDate *createDate;
@end

@interface DataStore : NSObject

@property(nonatomic, strong) NSMutableDictionary *fbFriends;
@property(nonatomic, strong) NSMutableArray *bookImgs;
@property(nonatomic, strong) NSMutableDictionary *bookMaps;

+(DataStore *)sharedInstance;
-(void)reset;

@end
