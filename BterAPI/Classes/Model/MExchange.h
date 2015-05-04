//
//  MExchange.h
//  BterAPI
//
//  Created by jianting on 14/10/13.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MExchange : NSObject

@property (nonatomic, retain) NSDate * exchangeDate;
@property (nonatomic, retain) NSString * exchangeType;
@property (nonatomic, retain) NSString * exchangeTicker;
@property (nonatomic, assign) CGFloat exchangePrice;
@property (nonatomic, assign) CGFloat exchangeAmount;

@end
