//
//  UIView+ModifyFram.h
//  MOP
//
//  Created by 杨朋亮 on 28/9/14.
//  Copyright (c) 2014年 NewLand. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 Before:
 CGRect frame = myView.frame;
 frame.origin.x = newX;
 myView.frame = frame;
 
 After:
 myView.x = newX;
 
 */

#import <UIKit/UIKit.h>

@interface UIView (Ext)

@property float x;
@property float y;
@property float width;
@property float height;

@end
