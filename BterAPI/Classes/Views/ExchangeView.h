//
//  ExchangeView.h
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 交易view
 */

@class ExchangeView;
@protocol ExchangeViewDelegate <NSObject>

- (void)exchangeViewWillDissapear:(ExchangeView *)view;

@end

@interface ExchangeView : UIView

@property (nonatomic, assign) id<ExchangeViewDelegate> delegate;

- (void)show;

@end
