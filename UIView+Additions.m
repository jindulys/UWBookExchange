//
//  UIView+Additions.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-8.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

+ (id) getSpecificNextResponder:(UIView *) view class:(Class) class;
{
    id nextResponder =  view.nextResponder;
    
    if (nextResponder == nil) {
        return nil;
    }
    
    if ([nextResponder isKindOfClass: class]) {
        return nextResponder;
    }else{
        return  [self getSpecificNextResponder:nextResponder class:class];
    }
}


@end
