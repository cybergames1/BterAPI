//
//  ExchangeIconView.h
//  BterAPI
//
//  Created by jianting on 14/10/17.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExchangeIconView;
@protocol ExchangeIconViewDelegate <NSObject>

- (void)exchangeIconViewTapped:(ExchangeIconView *)iconView;

@end

@interface ExchangeIconView : UIView

@property (nonatomic, assign) id<ExchangeIconViewDelegate> delegate;

- (void)willShow;
- (void)willDismiss;

@end
