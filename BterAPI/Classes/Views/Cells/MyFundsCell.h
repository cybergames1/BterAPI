//
//  MyFundsCell.h
//  BterAPI
//
//  Created by jianting on 14/10/12.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFundsCell : UITableViewCell

@property (nonatomic, retain) UILabel * tickerNameLabel;
@property (nonatomic, retain) UILabel * tickerAmountLabel;
@property (nonatomic, retain) UILabel * tickerCNYLabel;

- (void)resetCell;

@end
