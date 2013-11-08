//
//  UIImage+Scaling.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-7.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)

- (UIImage *) imageScaledToSize:(CGSize)size
{
	// Create the context for drawing the scaled image
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
	
    // Draw the image into this scaled rect
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
	
    // Capture the image and return it
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) imageScaledToFitSize:(CGSize)size
{
	// Calculate the required size
    CGFloat ratio = self.size.width / self.size.height;
    if (size.width / ratio <= size.height) {
        return [self imageScaledToSize:CGSizeMake(size.width, size.width / ratio)];
    } else {
        return [self imageScaledToSize:CGSizeMake(size.height * ratio, size.height)];
    }
}

@end
