//
//  MyTradesCell.m
//  BterAPI
//
//  Created by jianting on 14/10/13.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "MyTradesCell.h"
#import "UIView+Addition.h"
#import "NetworkConstant.h"

@implementation MyTradesCell

- (void)dealloc
{
    [_tradeDateLabel release];_tradeDateLabel = nil;
    [_tradeTypeLabel release];_tradeTypeLabel = nil;
    [_tradeNameLabel release];_tradeNameLabel = nil;
    [_tradePriceLabel release];_tradePriceLabel = nil;
    [_tradeAmountLabel release];_tradeAmountLabel = nil;
    [_tradeCNYLabel release];_tradeCNYLabel = nil;
    
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _tradeDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, (self.height - 40) / 2, 80, 40)];
        _tradeDateLabel.numberOfLines = 2;
        _tradeDateLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _tradeDateLabel.textAlignment = NSTextAlignmentCenter;
        _tradeDateLabel.backgroundColor = [UIColor clearColor];
        _tradeDateLabel.font = [UIFont systemFontOfSize:13];
        
        _tradeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tradeDateLabel.right + 5, (self.height - 20) / 2, 50, 20)];
        _tradeNameLabel.backgroundColor = [UIColor clearColor];
        _tradeNameLabel.font = [UIFont systemFontOfSize:13];
        
        _tradePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tradeNameLabel.right + 5, (self.height - 20) / 2, 60, 20)];
        _tradePriceLabel.backgroundColor = [UIColor clearColor];
        _tradePriceLabel.font = [UIFont systemFontOfSize:13];
        _tradePriceLabel.adjustsFontSizeToFitWidth = YES;
        
        _tradeAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tradePriceLabel.right + 5, (self.height - 20) / 2, 50, 20)];
        _tradeAmountLabel.backgroundColor = [UIColor clearColor];
        _tradeAmountLabel.font = [UIFont systemFontOfSize:13];
        _tradeAmountLabel.adjustsFontSizeToFitWidth = YES;
        
        _tradeCNYLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tradeAmountLabel.right + 5, (self.height - 20) / 2, 50, 20)];
        _tradeCNYLabel.backgroundColor = [UIColor clearColor];
        _tradeCNYLabel.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:_tradeDateLabel];
        [self.contentView addSubview:_tradeTypeLabel];
        [self.contentView addSubview:_tradeNameLabel];
        [self.contentView addSubview:_tradePriceLabel];
        [self.contentView addSubview:_tradeAmountLabel];
        [self.contentView addSubview:_tradeCNYLabel];
    }
    
    return self;
}

- (void)resetCell
{
    _tradeDateLabel.text = nil;
    _tradeTypeLabel.text = nil;
    _tradeNameLabel.text = nil;
    _tradePriceLabel.text = nil;
    _tradeAmountLabel.text = nil;
    _tradeCNYLabel.text = nil;
}

- (void)setIsBuy:(BOOL)isBuy
{
    for (UILabel *label in self.contentView.subviews)
    {
        label.textColor = isBuy ? Buy_Color : Sell_Color;
    }
}

@end
