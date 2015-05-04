//
//  TickerPicker.m
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "TickerPicker.h"
#import "UIView+Addition.h"

@interface TickerPicker () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView * _pickerView;
    UIView * _bgView;
    UIView * _navigationView;
    
    UIButton * _cancelButton;
    UIButton * _doneButton;
    
    NSInteger _pickerRow;
}

@end

@implementation TickerPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    [_tickers release];_tickers = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        _bgView = [[[UIView alloc] init] autorelease];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.0;
        
        _pickerView = [[[UIPickerView alloc] init] autorelease];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_bgView];
        [self addSubview:_pickerView];
        
        [self addNavigation];
    }
    
    return self;
}

- (void)addNavigation
{
    _navigationView = [[[UIView alloc] init] autorelease];
    _navigationView.backgroundColor = [UIColor whiteColor];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_navigationView];
    [self addSubview:_cancelButton];
    [self addSubview:_doneButton];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.frame = window.bounds;
    [window addSubview:self];
    
    _bgView.frame = self.bounds;
    
    _navigationView.frame = CGRectMake(0, self.bottom, self.width, 44);
    _cancelButton.frame = CGRectMake(15, _navigationView.top, 100, 44);
    _doneButton.frame = CGRectMake(self.width - 100, _cancelButton.top, 100, 44);
    
    _pickerView.frame = CGRectMake(0, _doneButton.bottom, self.width, 216);
    
    [self showWithAnimated];
}

- (void)dismiss
{
    [self dismissWithAnimated];
}

- (void)showWithAnimated
{
    [UIView animateWithDuration:0.25 animations:^{
        _bgView.alpha = 0.5;
        _pickerView.top -= _pickerView.height;
        _navigationView.top -= _pickerView.height;
        _cancelButton.top -= _pickerView.height;
        _doneButton.top -= _pickerView.height;
    }];
}

- (void)dismissWithAnimated
{
    [UIView animateWithDuration:0.25 animations:^{
        _bgView.alpha = 0.0;
        _pickerView.top += _pickerView.height;
        _navigationView.top += _pickerView.height;
        _cancelButton.top += _pickerView.height;
        _doneButton.top += _pickerView.height;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
     }];
}

#pragma mark -
#pragma mark Button Action

- (void)cancel
{
    [self dismiss];
}

- (void)done
{
    if (_delegate && [_delegate respondsToSelector:@selector(picker:didPickAtIndex:)])
    {
        [_delegate picker:self didPickAtIndex:_pickerRow];
    }
    
    [self dismiss];
}

#pragma mark -
#pragma mark UIPickerDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _tickers.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_tickers objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerRow = row;
}

@end
