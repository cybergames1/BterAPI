//
//  MTicker.m
//  BterAPI
//
//  Created by jianting on 14/10/12.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "MTicker.h"

@implementation MTicker

- (void)dealloc
{
    [_tickerName release];_tickerName = nil;
    
    [super dealloc];
}

@end
