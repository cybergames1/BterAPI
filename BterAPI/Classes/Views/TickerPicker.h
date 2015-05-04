//
//  TickerPicker.h
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TickerPicker;
@protocol TickerPickerDelegate <NSObject>

- (void)picker:(TickerPicker *)picker didPickAtIndex:(NSInteger)index;

@end

@interface TickerPicker : UIView

@property (nonatomic, retain) NSArray * tickers;
@property (nonatomic, assign) id<TickerPickerDelegate> delegate;

- (void)show;
- (void)dismiss;

@end
