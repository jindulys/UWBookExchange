//
//  NavigationTitleView.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-5.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "NavigationTitleView.h"

@implementation NavigationTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(id)initWithTitle:(NSString *)title{
    CGFloat fontSize = 19.f;
    if (IS_IOS_7_0_SYSTEM_AVAILABLE) {
        fontSize = 17.f;
    }
    CGSize size = [title sizeWithFont:[UIFont UWBESystemFontOfSize:fontSize]];
    size.width = size.width>200?200:size.width;
    if (!title || title.length == 0) {
        size.height = 19.f;
        size.width = 100.f;
    }
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, (44-size.height)/2, size.width, size.height)];
    self=[super initWithFrame:CGRectMake(0, 0, size.width, 44)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        titleLable.text = title;
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [UIColor blackColor];
        titleLable.font = [UIFont UWBESystemFontOfSize:fontSize];
        titleLable.tag = 1011;
        if (!title || title.length == 0) {
            titleLable.textAlignment = NSTextAlignmentCenter;
        }

        [self addSubview:titleLable];
        self.clipsToBounds = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

@end
