//
//  bookImgCell.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "bookImgCell.h"
@interface bookImgCell()

@property (nonatomic, strong) IBOutlet UIImageView *bookImg;
@property (nonatomic, strong) IBOutlet UIImageView *userPic;
@property (nonatomic, strong) IBOutlet UILabel *bookName;
@property (nonatomic, strong) IBOutlet UILabel *bookPrice;
@property (nonatomic, strong) IBOutlet UILabel *bookMajor;
@property (nonatomic, strong) IBOutlet UILabel* seedDate;
@property (nonatomic, strong) IBOutlet UILabel* userName;
@end

@implementation bookImgCell

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

-(IBAction)shareBookToFacebook:(id)sender{
    
}

@end
