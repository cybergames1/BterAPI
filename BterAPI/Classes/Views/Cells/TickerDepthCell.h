//
//  TickerDepthCell.h
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickerDepthCell : UITableViewCell

@property (nonatomic, retain) UIView  * bidsCountView;
@property (nonatomic, retain) UILabel * bidsCNYLabel;
@property (nonatomic, retain) UILabel * bidsCountLabel;
@property (nonatomic, retain) UILabel * bidsPriceLable;

@property (nonatomic, retain) UIView  * asksCountView;
@property (nonatomic, retain) UILabel * asksPriceLabel;
@property (nonatomic, retain) UILabel * asksCountLabel;
@property (nonatomic, retain) UILabel * asksCNYLabel;

- (void)resetCell;

@end
