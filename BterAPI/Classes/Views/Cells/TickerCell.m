//
//  TickerCell.m
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "TickerCell.h"

@implementation TickerCell

- (void)dealloc
{
    [_tickerNameLabel  release];
    [_tickerPriceLabel release];
    _tickerPriceLabel   =   nil;
    _tickerNameLabel    =   nil;
    
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
        _tickerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (self.bounds.size.height - 20) / 2, 150, 20)];
        _tickerNameLabel.backgroundColor = [UIColor clearColor];
        _tickerNameLabel.font = [UIFont systemFontOfSize:15];
        
        _tickerPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 170, (self.bounds.size.height - 20) / 2, 150, 20)];
        _tickerPriceLabel.textAlignment = NSTextAlignmentRight;
        _tickerPriceLabel.backgroundColor = [UIColor clearColor];
        _tickerPriceLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_tickerNameLabel];
        [self.contentView addSubview:_tickerPriceLabel];
    }
    
    return self;
}

- (void)resetCell
{
    _tickerNameLabel.text = nil;
    _tickerPriceLabel.text = nil;
    _tickerPriceLabel.textColor = [UIColor blackColor];
}

@end
