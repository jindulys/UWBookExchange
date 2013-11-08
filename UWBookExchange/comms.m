//
//  comms.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-4.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "comms.h"
#import "NSOperationQueue+SharedQueue.h"

NSString *const N_ImageDownloaded = @"N_ImageDownloaded";
@implementation comms

+(void)login:(id<commsDelegate>)delegate
{
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"user cancelled logged in");
            }else{
                NSLog(@"the error information is %@",error.localizedDescription);
            }
            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                [delegate commsDidLogin:NO];
            }
        }
        else{
            if (user.isNew) {
                NSLog(@"user signed up and logged in through facebook");
            }else{
                NSLog(@"user logged in through facebook");
            }
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary<FBGraphUser> *me=(NSDictionary<FBGraphUser> *)result;
                    [[PFUser currentUser] setObject:me.id forKey:@"fbId"];
                    [[PFUser currentUser] saveInBackground];
                    [[DataStore sharedInstance].fbFriends setObject:me forKey:me.id];
                }
                FBRequest *friendsRequest = [FBRequest requestForMyFriends];
                [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    NSArray *friends = result[@"data"];
                    for (NSDictionary <FBGraphUser> *friend in friends ) {
                        NSLog(@"My friend %@",friend.name);
                        [[DataStore sharedInstance].fbFriends setObject:friend forKey:friend.id];
                    }
                    if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                        [delegate commsDidLogin:YES];
                    }
                }];
            }];
        }
    }];
}

+(void)uploadImage:(UIImage *)image withBookName:(NSString *)bookName withPrice:(NSString *)price withMajor:(NSString *)major withComment:(NSString *)comment forDelegate:(id<commsDelegate>)delegate{
    NSData *bookImgData = UIImagePNGRepresentation(image);
    PFFile *bookFile = [PFFile fileWithName:@"img" data:bookImgData];
    [bookFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *bookImageObject = [PFObject objectWithClassName:@"bookImg"];
            bookImageObject[@"image"] = bookFile;
            bookImageObject[@"userFBId"] = [[PFUser currentUser] objectForKey:@"fbId"];
            bookImageObject[@"user"] = [PFUser currentUser].username;
            [bookImageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    PFObject *bookInfoObject = [PFObject objectWithClassName:@"bookInfo"];
                    bookInfoObject[@"bookName"] = bookName;
                    bookInfoObject[@"price"] = price;
                    bookInfoObject[@"majorTag"] = major;
                    bookInfoObject[@"user"] = [PFUser currentUser].username;
                    bookInfoObject[@"userFBId"] = [[PFUser currentUser] objectForKey:@"fbId"];
                    bookInfoObject[@"bookImgObjectId"] = bookImageObject.objectId;
                    [bookInfoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            PFObject *bookCommentObject = [PFObject objectWithClassName:@"bookComment"];
                            bookCommentObject[@"comment"] = comment;
                            bookCommentObject[@"user"] = [PFUser currentUser].username;
                            bookCommentObject[@"userFBId"] = [[PFUser currentUser] objectForKey:@"fbId"];
                            bookCommentObject[@"bookImgObjectId"] = bookImageObject.objectId;
                            [bookCommentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if ([delegate respondsToSelector:@selector(commsUploadImageFinished:)]) {
                                    [delegate commsUploadImageFinished:YES];
                                }
                            }];
                        }else{
                            if ([delegate respondsToSelector:@selector(commsUploadImageFinished:)]) {
                                [delegate commsUploadImageFinished:NO];
                            }
                        }
                    }];
                }else{
                    if ([delegate respondsToSelector:@selector(commsUploadImageFinished:)]) {
                        [delegate commsUploadImageFinished:NO];
                    }
                }
            }];
        }else{
            if ([delegate respondsToSelector:@selector(commsUploadImageFinished:)]) {
                [delegate commsUploadImageFinished:NO];
            }
        }
    } progressBlock:^(int percentDone) {
        if ([delegate respondsToSelector:@selector(commsUploadImageProgress:)]) {
            [delegate commsUploadImageProgress:percentDone];
        }
    }];
}

+(void)getBookImagesSince:(NSDate *)lastUpdate forDelegate:(id<commsDelegate>)delegate{
    NSArray *meAndFriends = [DataStore sharedInstance].fbFriends.allKeys;
    PFQuery *bookQuery = [PFQuery queryWithClassName:@"bookImg"];
    [bookQuery orderByAscending:@"createdAt"];
    [bookQuery whereKey:@"updatedAt" greaterThan:lastUpdate];
    [bookQuery whereKey:@"userFBId" containedIn:meAndFriends];
    [bookQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        __block NSDate *newLastDate = lastUpdate;
        if (error) {
            NSLog(@"Error occurs and is %@",error.localizedDescription);
        }else{
            [objects enumerateObjectsUsingBlock:^(PFObject *bookImg, NSUInteger idx, BOOL *stop) {
                //1. get the user FBGraphUser
                NSDictionary<FBGraphUser> *user = [[DataStore sharedInstance].fbFriends objectForKey:bookImg[@"userFBId"]];
                bookImgInfo *bookImageInfo = [[bookImgInfo alloc] init];
                [[NSOperationQueue pffileOperationQueue] addOperationWithBlock:^{
                    bookImageInfo.image = [UIImage imageWithData:[(PFFile *)bookImg[@"image"] getData]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:N_ImageDownloaded object:nil];
                }];
                
                bookImageInfo.objectId = bookImg.objectId;
                
                bookImageInfo.user = user;
                bookImageInfo.createdDate = bookImg.createdAt;
                if ([bookImg.updatedAt compare:newLastDate]==NSOrderedDescending) {
                    newLastDate = bookImg.updatedAt;
                }
                //2. store the wrapped bookImgInfo object
                [[DataStore sharedInstance].bookImgs insertObject:bookImageInfo atIndex:0];
                [[DataStore sharedInstance].bookMaps setObject:bookImageInfo forKey:bookImageInfo.objectId];
            }];
        }
        if ([delegate respondsToSelector:@selector(commsDidGetNewBookImages:)]) {
            [delegate commsDidGetNewBookImages:newLastDate];
        }
    }];
}

@end
