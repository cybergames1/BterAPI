//
//  MyFundsCell.m
//  BterAPI
//
//  Created by jianting on 14/10/12.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "MyFundsCell.h"
#import "UIView+Addition.h"

@implementation MyFundsCell

- (void)dealloc
{
    [_tickerNameLabel release];_tickerNameLabel = nil;
    [_tickerAmountLabel release];_tickerAmountLabel = nil;
    [_tickerCNYLabel release];_tickerCNYLabel = nil;
    
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
        _tickerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (self.height - 20) / 2, 150, 20)];
        _tickerNameLabel.backgroundColor = [UIColor clearColor];
        _tickerNameLabel.font = [UIFont systemFontOfSize:13];
        
        _tickerCNYLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 125, (self.height - 20) / 2, 110, 20)];
        _tickerCNYLabel.textAlignment = NSTextAlignmentRight;
        _tickerCNYLabel.backgroundColor = [UIColor clearColor];
        _tickerCNYLabel.font = [UIFont systemFontOfSize:13];
        
        _tickerAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tickerCNYLabel.left - 120, (self.height - 20) / 2, 120, 20)];
        _tickerAmountLabel.textAlignment = NSTextAlignmentRight;
        _tickerAmountLabel.backgroundColor = [UIColor clearColor];
        _tickerAmountLabel.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:_tickerNameLabel];
        [self.contentView addSubview:_tickerAmountLabel];
        [self.contentView addSubview:_tickerCNYLabel];
    }
    
    return self;
}

- (void)resetCell
{
    _tickerNameLabel.text = nil;
    _tickerCNYLabel.text = nil;
    _tickerAmountLabel.text = nil;
}

@end
