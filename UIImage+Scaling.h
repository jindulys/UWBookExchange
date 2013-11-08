//
//  UIImage+Scaling.h
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-7.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scaling)

- (UIImage *) imageScaledToSize:(CGSize)size;
- (UIImage *) imageScaledToFitSize:(CGSize)size;

@end
