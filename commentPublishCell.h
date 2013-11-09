//
//  commentPublishCell.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentPublishCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UITextField* txtComment;
@property (nonatomic, strong) bookImgInfo *bookImage;
@end
