//
//  TickerDepthCell.m
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "TickerDepthCell.h"
#import "UIView+Addition.h"
#import "NetworkConstant.h"

@implementation TickerDepthCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_bidsCountView release];_bidsCountView = nil;
    [_bidsPriceLable release];_bidsPriceLable = nil;
    [_bidsCountLabel release];_bidsCountLabel = nil;
    [_bidsCNYLabel release];_bidsCNYLabel = nil;
    
    [_asksCountView release];_asksCountView = nil;
    [_asksPriceLabel release];_asksPriceLabel = nil;
    [_asksCountLabel release];_asksCountLabel = nil;
    [_asksCNYLabel release];_asksCNYLabel = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _bidsCountView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 30) / 2, 0, 30)];
        _bidsCountView.backgroundColor = Buy_Color;
        
        _bidsCNYLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, (self.height - 20) / 2, 50, 20)];
        _bidsCNYLabel.backgroundColor = [UIColor clearColor];
        _bidsCNYLabel.textAlignment = NSTextAlignmentRight;
        _bidsCNYLabel.font = [UIFont systemFontOfSize:11];
        _bidsCNYLabel.adjustsFontSizeToFitWidth = YES;
        
        _bidsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bidsCNYLabel.right + 3, (self.height - 20) / 2, 50, 20)];
        _bidsCountLabel.backgroundColor = [UIColor clearColor];
        _bidsCountLabel.textAlignment = NSTextAlignmentRight;
        _bidsCountLabel.font = [UIFont systemFontOfSize:11];
        _bidsCountLabel.adjustsFontSizeToFitWidth = YES;
        
        _bidsPriceLable = [[UILabel alloc] initWithFrame:CGRectMake(_bidsCountLabel.right + 3, (self.height - 20) / 2, 50, 20)];
        _bidsPriceLable.backgroundColor = [UIColor clearColor];
        _bidsPriceLable.textAlignment = NSTextAlignmentRight;
        _bidsPriceLable.font = [UIFont systemFontOfSize:11];
        _bidsPriceLable.adjustsFontSizeToFitWidth = YES;
        
        _asksCountView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 30) / 2, 0, 30)];
        _asksCountView.backgroundColor = Sell_Color;
        
        _asksPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bidsPriceLable.right + 3, (self.height - 20) / 2, 50, 20)];
        _asksPriceLabel.backgroundColor = [UIColor clearColor];
        _asksPriceLabel.textAlignment = NSTextAlignmentRight;
        _asksPriceLabel.font = [UIFont systemFontOfSize:11];
        _asksPriceLabel.adjustsFontSizeToFitWidth = YES;
        
        _asksCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_asksPriceLabel.right + 3, (self.height - 20) / 2, 50, 20)];
        _asksCountLabel.backgroundColor = [UIColor clearColor];
        _asksCountLabel.textAlignment = NSTextAlignmentRight;
        _asksCountLabel.font = [UIFont systemFontOfSize:11];
        _asksCountLabel.adjustsFontSizeToFitWidth = YES;
        
        _asksCNYLabel = [[UILabel alloc] initWithFrame:CGRectMake(_asksCountLabel.right + 3, (self.height - 20) / 2, 50, 20)];
        _asksCNYLabel.backgroundColor = [UIColor clearColor];
        _asksCNYLabel.textAlignment = NSTextAlignmentRight;
        _asksCNYLabel.font = [UIFont systemFontOfSize:11];
        _asksCNYLabel.adjustsFontSizeToFitWidth = YES;
        
        _bidsCountView.right = _bidsPriceLable.right;
        _bidsCountView.width = _bidsCountView.right - _bidsCNYLabel.left;
        _asksCountView.left = _asksPriceLabel.left;
        _asksCountView.width = _bidsCountView.width;
        
        [self.contentView addSubview:_bidsCountView];
        [self.contentView addSubview:_bidsCNYLabel];
        [self.contentView addSubview:_bidsCountLabel];
        [self.contentView addSubview:_bidsPriceLable];
        [self.contentView addSubview:_asksCountView];
        [self.contentView addSubview:_asksPriceLabel];
        [self.contentView addSubview:_asksCountLabel];
        [self.contentView addSubview:_asksCNYLabel];
    }
    
    return self;
}

- (void)resetCell
{
    _bidsCNYLabel.text = nil;
    _bidsCountLabel.text = nil;
    _bidsPriceLable.text = nil;
    _asksCNYLabel.text = nil;
    _asksCountLabel.text = nil;
    _asksPriceLabel.text = nil;
    
    _bidsCountView.width = 0;
    _asksCountView.width = 0;
}

@end
