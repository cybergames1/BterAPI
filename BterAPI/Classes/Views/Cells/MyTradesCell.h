//
//  MyTradesCell.h
//  BterAPI
//
//  Created by jianting on 14/10/13.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTradesCell : UITableViewCell

@property (nonatomic, retain) UILabel * tradeDateLabel;
@property (nonatomic, retain) UILabel * tradeTypeLabel;
@property (nonatomic, retain) UILabel * tradeNameLabel;
@property (nonatomic, retain) UILabel * tradePriceLabel;
@property (nonatomic, retain) UILabel * tradeAmountLabel;
@property (nonatomic, retain) UILabel * tradeCNYLabel;

- (void)resetCell;

- (void)setIsBuy:(BOOL)isBuy;

@end
