//
//  UIView+Additions.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)
+ (id) getSpecificNextResponder:(UIView *) view class:(Class) class;
@end
