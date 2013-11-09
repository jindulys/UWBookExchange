//
//  comms.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-4.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const N_ImageDownloaded;
extern NSString * const N_ProfilePictureLoaded;
extern NSString * const N_CommentUploaded;
extern NSString * const N_ImageUploaded;

@protocol commsDelegate <NSObject>

@optional
-(void)commsDidLogin:(BOOL)loggedIn;
-(void)commsUploadImageProgress:(short)progress;
-(void)commsUploadImageFinished:(BOOL)success;
-(void)commsDidGetNewBookImages:(NSDate *)updated;
-(void)commsDidGetNewBookImageComments:(NSDate *)updated;
@end

@interface comms : NSObject

+(void)login:(id<commsDelegate>)delegate;
+(void)uploadImage:(UIImage *)image withBookName:(NSString *)bookName withPrice:(NSString *)price withMajor:(NSString *)major withComment:(NSString *)comment forDelegate:(id<commsDelegate>)delegate;
+(void)getBookImagesSince:(NSDate *)lastUpdate forDelegate:(id<commsDelegate>)delegate;
+(void)getBookImageCommentsSince:(NSDate *)lastUpdate forDelegate:(id<commsDelegate>)delegate;
+(void)addComment:(NSString *)comment toBookImage:(bookImgInfo *)bookImage;
@end
