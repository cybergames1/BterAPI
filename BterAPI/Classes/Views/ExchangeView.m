//
//  ExchangeView.m
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "ExchangeView.h"
#import "UIView+Addition.h"
#import "TickerPicker.h"
#import "CommonTools.h"
#import "PrivatePlaceOrderDS.h"

@interface ExchangeView () <PPQDataSourceDelegate,TickerPickerDelegate>
{
    UIView * _bgView;
    
    UIButton * _pickTickerButton;
    UIButton * _buyButton;
    UIButton * _sellButton;
    
    UITextField * _priceTextField;
    UITextField * _amountTextField;
    
    UIButton * _submitButton;
    
    UITapGestureRecognizer * _taprecognizer;
}

@property (nonatomic, retain) NSString * exchangeType;

@end

@implementation ExchangeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    [_exchangeType release];_exchangeType = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _bgView = [[[UIView alloc] init] autorelease];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.0;
        
        _pickTickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pickTickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pickTickerButton setTitle:@"请选择币种对" forState:UIControlStateNormal];
        [_pickTickerButton addTarget:self action:@selector(pickerTicker:) forControlEvents:UIControlEventTouchUpInside];
        
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [_buyButton setTitle:@"buy" forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyTicker:) forControlEvents:UIControlEventTouchUpInside];
        [_buyButton setSelected:YES];
        
        _sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sellButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [_sellButton setTitle:@"sell" forState:UIControlStateNormal];
        [_sellButton addTarget:self action:@selector(sellTicker:) forControlEvents:UIControlEventTouchUpInside];
        
        _priceTextField = [[UITextField alloc] init];
        _priceTextField.placeholder = @"价格";
        _priceTextField.borderStyle = UITextBorderStyleBezel;
        _priceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        _amountTextField = [[UITextField alloc] init];
        _amountTextField.placeholder = @"数量";
        _amountTextField.borderStyle = UITextBorderStyleBezel;
        _amountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitTicker:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_bgView];
        [self addSubview:_pickTickerButton];
        [self addSubview:_buyButton];
        [self addSubview:_sellButton];
        [self addSubview:_priceTextField];
        [self addSubview:_amountTextField];
        [self addSubview:_submitButton];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:recognizer];
        [recognizer release];
        _taprecognizer = recognizer;
        
        self.exchangeType = _buyButton.titleLabel.text;
    }
    
    return self;
}

- (void)pickerTicker:(UIButton *)sender
{
    TickerPicker *tickerPicker = [[TickerPicker alloc] init];
    tickerPicker.delegate = self;
    tickerPicker.tickers = [NSArray arrayWithContentsOfFile:[[CommonTools pathForCachedTickers] stringByAppendingPathComponent:CachedTickersPath]];
    [tickerPicker show];
    [tickerPicker release];
}

- (void)buyTicker:(UIButton *)sender
{
    sender.selected = YES;
    _sellButton.selected = NO;
    self.exchangeType = sender.titleLabel.text;
}

- (void)sellTicker:(UIButton *)sender
{
    sender.selected = YES;
    _buyButton.selected = NO;
    self.exchangeType = sender.titleLabel.text;
}

- (void)submitTicker:(UIButton *)sender
{
    _taprecognizer.enabled = NO;
    
    PrivatePlaceOrderDS *ds = [[PrivatePlaceOrderDS alloc] initWithDelegate:self];
    [ds placeOrderWithTicker:_pickTickerButton.titleLabel.text type:_exchangeType rate:[_priceTextField.text floatValue] amount:[_amountTextField.text floatValue]];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.frame = window.bounds;
    [window addSubview:self];
    
    _bgView.frame = self.bounds;
    _pickTickerButton.frame = CGRectMake((self.width - 150) / 2, 50, 150, 30);
    _buyButton.frame = CGRectMake(_pickTickerButton.left, _pickTickerButton.bottom + 15, 50, 30);
    _sellButton.frame = CGRectMake(0, _buyButton.top, 50, 30);
    _sellButton.right = _pickTickerButton.right;
    _priceTextField.frame = CGRectMake((self.width - 200) / 2, _sellButton.bottom + 15, 200, 30);
    _amountTextField.frame = CGRectMake(_priceTextField.left, _priceTextField.bottom + 15, 200, 30);
    _submitButton.frame = CGRectMake(_pickTickerButton.left, _amountTextField.bottom + 15, 150, 30);
    
    [self showWithAnimated];
}

- (void)dismiss
{
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeViewWillDissapear:)])
    {
        [_delegate exchangeViewWillDissapear:self];
    }
    
    for (UIView *view in self.subviews)
    {
        if (view != _bgView)
        {
            [view removeFromSuperview];
        }
    }
    
    [self dismissWithAnimated];
}

- (void)showWithAnimated
{
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.alpha = 0.9;
    }];
}

- (void)dismissWithAnimated
{
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.alpha = 0.0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}


- (void)tapAction:(UIGestureRecognizer *)recognizer
{
    [self dismiss];
}

#pragma mark -
#pragma mark DataSource Delegate

- (void)dataSourceFinishLoad:(PPQDataSource *)source
{
    [source release];source = nil;
    [self dismiss];
}

- (void)dataSource:(PPQDataSource *)source hasError:(NSError *)error
{
    [source release];source = nil;
}

#pragma mark -
#pragma mark TickerPicker Delegate

- (void)picker:(TickerPicker *)picker didPickAtIndex:(NSInteger)index
{
    NSArray * tickers = [NSArray arrayWithContentsOfFile:[[CommonTools pathForCachedTickers] stringByAppendingPathComponent:CachedTickersPath]];
    [_pickTickerButton setTitle:[tickers objectAtIndex:index] forState:UIControlStateNormal];
}

@end
