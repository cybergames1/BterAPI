//
//  ExchangeIconView.m
//  BterAPI
//
//  Created by jianting on 14/10/17.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "ExchangeIconView.h"
#import "UIView+Addition.h"

enum {
    MoveDirectTop,
    MoveDirectLeft,
    MoveDirectBottom,
    MoveDirectRight
};
typedef NSInteger MoveDirect;

@interface ExchangeIconView ()
{
    UILabel * _label;
    
    CGPoint _netTranslation;
    
    CGRect _windowBounds;
}

@property (nonatomic, retain) NSTimer * hideTimer;

@end

@implementation ExchangeIconView

- (void)dealloc
{
    [_hideTimer release];_hideTimer = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        
        _label = [[[UILabel alloc] initWithFrame:self.bounds] autorelease];
        _label.backgroundColor = [UIColor clearColor];
        _label.text = @"交易";
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
        [self addGestureRecognizer:panRecognizer];
        [panRecognizer release];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        _windowBounds = window.bounds;
    }
    
    return self;
}

- (void)willShow
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.5;
    }];
}

- (void)willDismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    }];
}

- (void)showSelf
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hideSelf
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.5;
    }];
}

- (void)addTimer
{
    if (_hideTimer)
    {
        [_hideTimer invalidate];
    }
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideSelf) userInfo:nil repeats:NO];
}

- (void)removeTimer
{
    if (_hideTimer)
    {
        [_hideTimer invalidate];
    }
    self.hideTimer = nil;
}

- (void)animationWithDirect:(MoveDirect)direct
{
    if (direct == MoveDirectTop)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.top = 0;
        }];
    }
    else if (direct == MoveDirectLeft)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.left = 0;
        }];
    }
    else if (direct == MoveDirectBottom)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottom = _windowBounds.size.height;
        }];
    }
    else if (direct == MoveDirectRight)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.right = _windowBounds.size.width;
        }];
    }
    else
    {
        //
    }
}

- (void)moveAction:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _netTranslation = self.frame.origin;
            
            [self removeTimer];
            
            [self showSelf];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self];
            
            self.left = _netTranslation.x + translation.x;
            self.top = _netTranslation.y + translation.y;
            if (self.left <= 0) self.left = 0;
            if (self.left >= _windowBounds.size.width) self.right = _windowBounds.size.width;
            if (self.top <= 0) self.top = 0;
            if (self.top >= _windowBounds.size.height) self.bottom = _windowBounds.size.height;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self addTimer];
            
            if (self.top <= 64 && self.left <= 64) //左上角区域
            {
                if (self.top < self.left) //靠近上面
                {
                    [self animationWithDirect:MoveDirectTop];
                }
                else //靠近左面
                {
                    [self animationWithDirect:MoveDirectLeft];
                }
            }
            else if (self.top <= 64 && self.right >= _windowBounds.size.width - 64) //右上角区域
            {
                if (self.top < _windowBounds.size.width - self.right)
                {
                    [self animationWithDirect:MoveDirectTop];
                }
                else
                {
                    [self animationWithDirect:MoveDirectRight];
                }
            }
            else if (self.bottom >= _windowBounds.size.height - 64 && self.left <= 64) //左下角区域
            {
                if (_windowBounds.size.height - self.bottom < self.left)
                {
                    [self animationWithDirect:MoveDirectBottom];
                }
                else
                {
                    [self animationWithDirect:MoveDirectLeft];
                }
            }
            else if (self.bottom >= _windowBounds.size.height - 64 && self.right >= _windowBounds.size.width - 64) //右下角区域
            {
                if (_windowBounds.size.height - self.bottom < _windowBounds.size.width - self.right)
                {
                    [self animationWithDirect:MoveDirectBottom];
                }
                else
                {
                    [self animationWithDirect:MoveDirectRight];
                }
            }
            else
            {
                if (self.top <= 64) //上
                {
                    [self animationWithDirect:MoveDirectTop];
                }
                else if (self.bottom >= _windowBounds.size.height - 64) //下
                {
                    [self animationWithDirect:MoveDirectBottom];
                }
                else if (self.center.x < _windowBounds.size.width/2) //左
                {
                    [self animationWithDirect:MoveDirectLeft];
                }
                else // 右
                {
                    [self animationWithDirect:MoveDirectRight];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)tapAction:(UIGestureRecognizer *)recognizer
{
    [self willDismiss];
    
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeIconViewTapped:)])
    {
        [_delegate exchangeIconViewTapped:self];
    }
}

@end
