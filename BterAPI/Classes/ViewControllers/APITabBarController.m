//
//  APITabBarController.m
//  BterAPI
//
//  Created by jianting on 14/10/17.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "APITabBarController.h"
#import "UIView+Addition.h"
#import "ExchangeIconView.h"
#import "ExchangeView.h"

@interface APITabBarController () <ExchangeIconViewDelegate,ExchangeViewDelegate>
{
    ExchangeIconView * _iconView;
}

@end

@implementation APITabBarController

- (void)viewDidAppear:(BOOL)animated
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    ExchangeIconView *iconView = [[ExchangeIconView alloc] initWithFrame:CGRectMake(window.width - 60, 80, 60, 60)];
    iconView.delegate = self;
    [[[UIApplication sharedApplication].delegate window] addSubview:iconView];
    [iconView release];
    _iconView = iconView;
}

#pragma mark -
#pragma mark ExchangeIconView Delegate

- (void)exchangeIconViewTapped:(ExchangeIconView *)iconView
{
    ExchangeView *exchangeView = [[ExchangeView alloc] init];
    [exchangeView setDelegate:self];
    [exchangeView show];
    [exchangeView release];
}

#pragma mark -
#pragma mark ExchangeView Delegate

- (void)exchangeViewWillDissapear:(ExchangeView *)view
{
    [_iconView willShow];
}

@end
