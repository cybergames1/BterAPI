//
//  MExchange.m
//  BterAPI
//
//  Created by jianting on 14/10/13.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "MExchange.h"

@implementation MExchange

- (void)dealloc
{
    [_exchangeDate release];_exchangeDate = nil;
    [_exchangeType release];_exchangeType = nil;
    [_exchangeTicker release];_exchangeTicker = nil;
    
    [super dealloc];
}

@end
