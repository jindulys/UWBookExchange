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
NSString *const N_ProfilePictureLoaded = @"N_ProfilePictureLoaded";
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
                    [[NSOperationQueue profilePictureOperationQueue] addOperationWithBlock:^{
                        NSString *profilePictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",me.id];
                        NSData *profilePictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profilePictureURL]];
                        UIImage *profilePicture = [UIImage imageWithData:profilePictureData];
                        if (profilePicture) {
                            [me setObject:profilePicture forKey:@"fbProfilePicture"];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:N_ProfilePictureLoaded object:nil];
                    }];
                    [[DataStore sharedInstance].fbFriends setObject:me forKey:me.id];
                }
                FBRequest *friendsRequest = [FBRequest requestForMyFriends];
                [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    NSArray *friends = result[@"data"];
                    for (NSDictionary <FBGraphUser> *friend in friends ) {
                        NSLog(@"My friend %@",friend.name);
                        [[NSOperationQueue profilePictureOperationQueue] addOperationWithBlock:^{
                            NSString *profilePictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",friend.id];
                            NSData *profilePictureData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profilePictureURL]];
                            UIImage *profilePicture = [UIImage imageWithData:profilePictureData];
                            if (profilePicture){
                                [friend setObject:profilePicture forKey:@"fbProfilePicture"];
                            }
                            [[NSNotificationCenter defaultCenter] postNotificationName:N_ProfilePictureLoaded object:nil];
                        }];
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
            bookImageObject[@"bookName"] = bookName;
            bookImageObject[@"price"] = price;
            bookImageObject[@"majorTag"] = major;
            [bookImageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
                bookImageInfo.bookName = bookImg[@"bookName"];
                bookImageInfo.bookPrice = bookImg[@"price"];
                bookImageInfo.bookMajor = bookImg[@"majorTag"];
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

+(void)getBookImageCommentsSince:(NSDate *)lastUpdate forDelegate:(id<commsDelegate>)delegate{
    //1. get all bookImageid
    NSArray *bookImgIdArray = [DataStore sharedInstance].bookMaps.allKeys;
    //2. set the query message
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"bookComment"];
    [commentQuery orderByAscending:@"createdAt"];
    [commentQuery whereKey:@"bookImgObjectId" containedIn:bookImgIdArray];
    [commentQuery whereKey:@"updatedAt" greaterThan:lastUpdate];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        __block NSDate *newLastUpdate = lastUpdate;
        if (error) {
            NSLog(@"some error occurs at commentQuery %@",error.localizedDescription);
        }else{
            [objects enumerateObjectsUsingBlock:^(PFObject *bookImgCommentObject, NSUInteger idx, BOOL *stop) {
                NSDictionary <FBGraphUser> *user = [[DataStore sharedInstance].fbFriends objectForKey:bookImgCommentObject[@"userFBId"]];
                bookImgInfo *bookImageInfo = [[DataStore sharedInstance].bookMaps objectForKey:bookImgCommentObject[@"bookImgObjectId"]];
                if (bookImageInfo) {
                    bookComment *comment = [[bookComment alloc] init];
                    comment.user = user;
                    comment.comment = bookImgCommentObject[@"comment"];
                    comment.createDate = bookImgCommentObject[@"updatedAt"];
                    if ([bookImgCommentObject.updatedAt compare:newLastUpdate] == NSOrderedDescending) {
                        newLastUpdate = bookImgCommentObject.updatedAt;
                    }
                    [bookImageInfo.comments addObject:comment];
                }
                
            }];
            
            if ([delegate respondsToSelector:@selector(commsDidGetNewBookImageComments:)]) {
                [delegate commsDidGetNewBookImageComments:newLastUpdate];
            }
        }
    }];
}

@end
