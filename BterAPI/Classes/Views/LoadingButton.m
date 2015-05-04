//
//  LoadingButton.m
//  BterAPI
//
//  Created by jianting on 14/10/17.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "LoadingButton.h"
#import "UIView+Addition.h"

@interface LoadingButton ()
{
    UIActivityIndicatorView * _indicatorView;
}

@end

@implementation LoadingButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super init];
    if (self)
    {
        _indicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectZero] autorelease];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _indicatorView.frame = CGRectMake((self.width - 20)/2, (self.height - 20)/2, 20, 20);
}

- (void)startLoading
{
    [_indicatorView startAnimating];
}

- (void)stopLoading
{
    [_indicatorView stopAnimating];
}

@end
