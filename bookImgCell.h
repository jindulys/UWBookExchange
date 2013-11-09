//
//  bookImgCell.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookImgCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *bookPic;
@property (nonatomic, strong) IBOutlet UIImageView *userPic;
@property (nonatomic, strong) IBOutlet UILabel *bookName;
@property (nonatomic, strong) IBOutlet UILabel *bookPrice;
@property (nonatomic, strong) IBOutlet UILabel *bookMajor;
@property (nonatomic, strong) IBOutlet UILabel* seedDate;
@property (nonatomic, strong) IBOutlet UILabel* userName;
@end
