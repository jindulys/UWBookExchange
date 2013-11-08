//
//  bookCommentCell.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "bookCommentCell.h"

@interface bookCommentCell()
@property (nonatomic, strong) IBOutlet UIImageView* userPic;
@property (nonatomic, strong) IBOutlet UILabel* comment;
@property (nonatomic, strong) IBOutlet UILabel* userName;
@end

@implementation bookCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
