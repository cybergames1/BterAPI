//
//  TickerDetailViewController.m
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "TickerDetailViewController.h"
#import "TickerDepthDS.h"
#import "TickerTradeDS.h"
#import "UIView+Addition.h"
#import "TickerDepthCell.h"
#import "MyTradesCell.h"
#import "PrivateOrderStatusDS.h"
#import "ExchangeView.h"
#import "CommonTools.h"
#import "UIView+Addition.h"

@interface TickerDetailViewController () <PPQDataSourceDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _depthTableView;
    UITableView * _tradeTableView;
    
    TickerDepthDS * _tickerDepthDS;
    TickerTradeDS * _tickerTradeDS;
    
    NSMutableArray * _bidsList;
    NSMutableArray * _asksList;
    NSMutableArray * _tradeList;
}

@end

@implementation TickerDetailViewController

- (void)dealloc
{
    if (_tickerDepthDS)
    {
        [_tickerDepthDS cancelAllRequest];
        _tickerDepthDS.delegate = nil;
        [_tickerDepthDS release];_tickerDepthDS = nil;
    }
    
    if (_tickerTradeDS)
    {
        [_tickerTradeDS cancelAllRequest];
        _tickerTradeDS.delegate = nil;
        [_tickerTradeDS release];_tickerTradeDS = nil;
    }
    
    [_bidsList release];_bidsList = nil;
    [_asksList release];_asksList = nil;
    [_tradeList release];_tradeList = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _ticker;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"挂单深度",@"交易记录", nil]];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [segmentedControl release];
    [segmentedControl setFrame:CGRectMake((self.view.width - 250)/2, 64 + 10, 250, 40)];
    segmentedControl.selectedSegmentIndex = 0;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.top = segmentedControl.bottom + 10;
    tableView.height -= tableView.top + self.tabBarController.tabBar.height;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView release];
    _depthTableView = tableView;
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.frame = _depthTableView.frame;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView release];
    _tradeTableView = tableView;
    
    _bidsList = [[NSMutableArray alloc] initWithCapacity:0];
    _asksList = [[NSMutableArray alloc] initWithCapacity:0];
    _tradeList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self segmentedControlAction:segmentedControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlAction:(UISegmentedControl *)segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
        {
            if ([_bidsList count] == 0)
            {
                _tickerDepthDS = [[TickerDepthDS alloc] initWithDelegate:self];
                [_tickerDepthDS tickerDepth:_ticker];
            }
            _tradeTableView.hidden = YES;
            _depthTableView.hidden = NO;
        }
            break;
        case 1:
        {
            if ([_tradeList count] == 0)
            {
                _tickerTradeDS = [[TickerTradeDS alloc] initWithDelegate:self];
                [_tickerTradeDS tickerTrade:_ticker];
            }
            _tradeTableView.hidden = NO;
            _depthTableView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _depthTableView)
    {
        return MAX(_bidsList.count, _asksList.count);
    }
    else
    {
        return _tradeList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _depthTableView)
    {
        static NSString *depthidentifier = @"TickerDepthCell";
        
        TickerDepthCell *cell = [tableView dequeueReusableCellWithIdentifier:depthidentifier];
        if (cell == nil)
        {
            cell = [[[TickerDepthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:depthidentifier] autorelease];
        }
        
        [cell resetCell];
        
        if (indexPath.row < _bidsList.count)
        {
            //每个对都是数组，数组第一个是价格，第二个是量
            NSArray *detail = [_bidsList objectAtIndex:indexPath.row];
            
            cell.bidsCountLabel.text = [CommonTools stringValueForFloat:[detail[1] floatValue]];
            cell.bidsPriceLable.text = [CommonTools stringValueForFloat:[detail[0] floatValue]];
            cell.bidsCNYLabel.text = [CommonTools stringValueForFloat:[detail[0] floatValue] * [detail[1] floatValue]];
            
            cell.bidsCountView.left = cell.bidsCNYLabel.left + (cell.bidsPriceLable.right - cell.bidsCNYLabel.left) * (1.00f - Rate([cell.bidsCNYLabel.text floatValue]));
            cell.bidsCountView.width = (cell.bidsPriceLable.right - cell.bidsCNYLabel.left) * Rate([cell.bidsCNYLabel.text floatValue]);
            
        }
        
        if (indexPath.row < _asksList.count)
        {
            NSArray *detail = [_asksList objectAtIndex:_asksList.count - 1 - indexPath.row];
            
            cell.asksCountLabel.text = [CommonTools stringValueForFloat:[detail[1] floatValue]];
            cell.asksPriceLabel.text = [CommonTools stringValueForFloat:[detail[0] floatValue]];
            cell.asksCNYLabel.text = [CommonTools stringValueForFloat:[detail[0] floatValue] * [detail[1] floatValue]];
            
            cell.asksCountView.width = (cell.bidsCountView.right - cell.bidsCNYLabel.left) * Rate([cell.asksCNYLabel.text floatValue]);
            
        }
        
        return cell;
    }
    else
    {
        static NSString *tradeidentifier = @"TradeCell";
        
        MyTradesCell *cell = [tableView dequeueReusableCellWithIdentifier:tradeidentifier];
        if (cell == nil)
        {
            cell = [[[MyTradesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tradeidentifier] autorelease];
        }
        
        [cell resetCell];
        
        NSDictionary *dic = [_tradeList objectAtIndex:indexPath.row];
        
        cell.tradeDateLabel.text = [CommonTools formateDateValue:[NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"date"] longLongValue]] withStyle:@"MM-dd HH:mm"];
        cell.tradeTypeLabel.text = [dic valueForKey:@"type"];
        cell.tradeNameLabel.text = _ticker;
        cell.tradePriceLabel.text = [CommonTools stringValueForFloat:[[dic valueForKey:@"price"] floatValue]];
        cell.tradeAmountLabel.text = [CommonTools stringValueForFloat:[[dic valueForKey:@"amount"] floatValue]];
        cell.tradeCNYLabel.text = [CommonTools stringValueForFloat:[cell.tradePriceLabel.text floatValue] * [cell.tradeAmountLabel.text floatValue]];
        [cell setIsBuy:[[dic valueForKey:@"type"] compare:@"buy" options:NSCaseInsensitiveSearch] == NSOrderedSame];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _depthTableView) return 30.0f;
    else return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _depthTableView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel * _bidsCNYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(3, (view.height - 20) / 2, 50, 20)] autorelease];
        _bidsCNYLabel.backgroundColor = [UIColor clearColor];
        _bidsCNYLabel.textAlignment = NSTextAlignmentCenter;
        _bidsCNYLabel.font = [UIFont systemFontOfSize:15];
        _bidsCNYLabel.textColor = Buy_Color;
        _bidsCNYLabel.text = @"总计";
        
        UILabel * _bidsCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_bidsCNYLabel.right + 3, (view.height - 20) / 2, 50, 20)] autorelease];
        _bidsCountLabel.backgroundColor = [UIColor clearColor];
        _bidsCountLabel.textAlignment = NSTextAlignmentCenter;
        _bidsCountLabel.font = [UIFont systemFontOfSize:15];
        _bidsCountLabel.textColor = Buy_Color;
        _bidsCountLabel.text = @"数量";
        
        UILabel * _bidsPriceLable = [[[UILabel alloc] initWithFrame:CGRectMake(_bidsCountLabel.right + 3, (view.height - 20) / 2, 50, 20)] autorelease];
        _bidsPriceLable.backgroundColor = [UIColor clearColor];
        _bidsPriceLable.textAlignment = NSTextAlignmentRight;
        _bidsPriceLable.font = [UIFont systemFontOfSize:15];
        _bidsPriceLable.textColor = Buy_Color;
        _bidsPriceLable.text = @"买入价";
        
        UILabel * _asksPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_bidsPriceLable.right + 3, (view.height - 20) / 2, 50, 20)] autorelease];
        _asksPriceLabel.backgroundColor = [UIColor clearColor];
        _asksPriceLabel.textAlignment = NSTextAlignmentCenter;
        _asksPriceLabel.font = [UIFont systemFontOfSize:15];
        _asksPriceLabel.textColor = Sell_Color;
        _asksPriceLabel.text = @"卖出价";
        
        UILabel * _asksCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_asksPriceLabel.right + 3, (view.height - 20) / 2, 50, 20)] autorelease];
        _asksCountLabel.backgroundColor = [UIColor clearColor];
        _asksCountLabel.textAlignment = NSTextAlignmentCenter;
        _asksCountLabel.font = [UIFont systemFontOfSize:15];
        _asksCountLabel.textColor = Sell_Color;
        _asksCountLabel.text = @"数量";
        
        UILabel * _asksCNYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_asksCountLabel.right + 3, (view.height - 20) / 2, 50, 20)] autorelease];
        _asksCNYLabel.backgroundColor = [UIColor clearColor];
        _asksCNYLabel.textAlignment = NSTextAlignmentCenter;
        _asksCNYLabel.font = [UIFont systemFontOfSize:15];
        _asksCNYLabel.textColor = Sell_Color;
        _asksCNYLabel.text = @"总计";
        
        [view addSubview:_bidsCNYLabel];
        [view addSubview:_bidsCountLabel];
        [view addSubview:_bidsPriceLable];
        [view addSubview:_asksPriceLabel];
        [view addSubview:_asksCountLabel];
        [view addSubview:_asksCNYLabel];
        
        return [view autorelease];
    }
    else
    {
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dataSourceFinishLoad:(PPQDataSource *)source
{
    if (source == _tickerDepthDS)
    {
        [_asksList addObjectsFromArray:[source.data valueForKey:@"asks"]];
        [_bidsList addObjectsFromArray:[source.data valueForKey:@"bids"]];
        
        [_tickerDepthDS release];_tickerDepthDS = nil;
        
        [_depthTableView reloadData];
    }
    else if (source == _tickerTradeDS)
    {
        [_tradeList removeAllObjects];
        [_tradeList addObjectsFromArray:[source.data valueForKey:@"data"]];
        [_tickerTradeDS release];_tickerTradeDS = nil;
        
        [_tradeTableView reloadData];
    }
    else
    {
        [source release];source = nil;
    }
}

- (void)dataSource:(PPQDataSource *)source hasError:(NSError *)error
{
    if (source == _tickerDepthDS)
    {
        [_tickerDepthDS release];_tickerDepthDS = nil;
    }
    else if (source == _tickerTradeDS)
    {
        [_tickerTradeDS release];_tickerTradeDS = nil;
    }
    else
    {
        [source release];source = nil;
    }
}

@end
