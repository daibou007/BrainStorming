//
//  UIView+Extension.m
//  SZMoni
//
//  Created by Lee Joker on 3/13/14.
//  Copyright (c) 2014 com.newland. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)clear
{
	for(UIView *v in self.subviews) {
		[v removeFromSuperview];
	}
}

@end
