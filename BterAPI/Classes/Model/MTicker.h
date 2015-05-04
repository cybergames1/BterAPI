//
//  MTicker.h
//  BterAPI
//
//  Created by jianting on 14/10/12.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTicker : NSObject

@property (nonatomic, retain) NSString * tickerName;
@property (nonatomic, assign) CGFloat tickerPrice;
@property (nonatomic, assign) CGFloat tickerHighPrice;
@property (nonatomic, assign) CGFloat tickerLowPrice;
@property (nonatomic, assign) CGFloat tickerAmount;

@end
