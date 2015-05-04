//
//  TickerCell.h
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickerCell : UITableViewCell

@property (nonatomic, retain) UILabel * tickerNameLabel;
@property (nonatomic, retain) UILabel * tickerPriceLabel;

- (void)resetCell;

@end
