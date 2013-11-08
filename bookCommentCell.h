//
//  bookCommentCell.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookCommentCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView* userPic;
@property (nonatomic, strong) IBOutlet UILabel* comment;
@property (nonatomic, strong) IBOutlet UILabel* userName;
@end
