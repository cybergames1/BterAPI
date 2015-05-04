//
//  TradesViewController.m
//  BterAPI
//
//  Created by jianting on 14/10/13.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "TradesViewController.h"
#import "TickerPicker.h"
#import "CommonTools.h"
#import "PrviateTradesDS.h"
#import "UIView+Addition.h"
#import "MyTradesCell.h"

@interface TradesViewController () <TickerPickerDelegate,UITableViewDataSource,UITableViewDelegate,PPQDataSourceDelegate>
{
    UIButton * _pickTickerButton;
    PrviateTradesDS * _tradesDS;
    
    UITableView * _tableView;
    
    UILabel * _buyAmountLabel;
    UILabel * _buyCNYLabel;
    UILabel * _sellAmountLabel;
    UILabel * _sellCNYLabel;
    
    NSMutableArray * _tradeList;
}

@end

@implementation TradesViewController

- (void)dealloc
{
    if (_tradesDS)
    {
        [_tradesDS cancelAllRequest];
        _tradesDS.delegate = nil;
        [_tradesDS release];_tradesDS = nil;
    }
    
    [_tradeList release];_tradeList = nil;
    
    [super dealloc];
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        _tradeList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的交易记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _pickTickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pickTickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pickTickerButton setTitle:@"请选择币种对" forState:UIControlStateNormal];
    [_pickTickerButton addTarget:self action:@selector(pickerTicker:) forControlEvents:UIControlEventTouchUpInside];
    [_pickTickerButton setFrame:CGRectMake((self.view.width - 150) / 2, 64 + 10, 150, 30)];
    [self.view addSubview:_pickTickerButton];
    
    [self setTotalView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.top = _sellCNYLabel.bottom + 5;
    tableView.height -= tableView.top + self.tabBarController.tabBar.height;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    _tableView = tableView;
}

- (void)setTotalView
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, _pickTickerButton.bottom + 10, 0, 0)] autorelease];
    label.text = @"买入总计";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _buyAmountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 0, 0)] autorelease];
    _buyAmountLabel.backgroundColor = [UIColor clearColor];
    _buyAmountLabel.text = @"0";
    _buyAmountLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_buyAmountLabel];
    
    label = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 100, label.top, 0, 0)] autorelease];
    label.text = @"约";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _buyCNYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 0, 0)] autorelease];
    _buyCNYLabel.backgroundColor = [UIColor clearColor];
    _buyCNYLabel.text = @"0 人民币";
    _buyCNYLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_buyCNYLabel];
    [_buyCNYLabel sizeToFit];
    
    label = [[[UILabel alloc] initWithFrame:CGRectMake(15, label.bottom + 5, 0, 0)] autorelease];
    label.text = @"卖出总计";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _sellAmountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 0, 0)] autorelease];
    _sellAmountLabel.backgroundColor = [UIColor clearColor];
    _sellAmountLabel.text = @"0";
    _sellAmountLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_sellAmountLabel];
    
    label = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 100, label.top, 0, 0)] autorelease];
    label.text = @"约";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _sellCNYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 0, 20)] autorelease];
    _sellCNYLabel.backgroundColor = [UIColor clearColor];
    _sellCNYLabel.text = @"0 人民币";
    _sellCNYLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_sellCNYLabel];
    [_sellCNYLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tradeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tradeidentifier = @"TradesCell";
    
    MyTradesCell *cell = [tableView dequeueReusableCellWithIdentifier:tradeidentifier];
    if (cell == nil)
    {
        cell = [[[MyTradesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tradeidentifier] autorelease];
    }
    
    [cell resetCell];
    
    NSDictionary *dic = [_tradeList objectAtIndex:indexPath.row];
    
    cell.tradeDateLabel.text = [CommonTools formateDateValue:[NSDate dateWithTimeIntervalSince1970:[[dic valueForKey:@"time_unix"] longLongValue]] withStyle:@"YYYY-MM-dd HH:mm:ss"];
    cell.tradeTypeLabel.text = [dic valueForKey:@"type"];
    cell.tradeNameLabel.text = [dic valueForKey:@"pair"];
    cell.tradePriceLabel.text = [CommonTools stringValue:[dic valueForKey:@"rate"]];
    cell.tradeAmountLabel.text = [CommonTools stringValue:[dic valueForKey:@"amount"]];
    cell.tradeCNYLabel.text = [CommonTools stringValueForFloat:[[dic valueForKey:@"rate"] floatValue] * [[dic valueForKey:@"amount"] floatValue]];
    [cell setIsBuy:[cell.tradeTypeLabel.text compare:@"buy" options:NSCaseInsensitiveSearch] == NSOrderedSame];
    
    return cell;
}


- (void)pickerTicker:(UIButton *)sender
{
    TickerPicker *tickerPicker = [[TickerPicker alloc] init];
    tickerPicker.delegate = self;
    tickerPicker.tickers = [NSArray arrayWithContentsOfFile:[[CommonTools pathForCachedTickers] stringByAppendingPathComponent:CachedTickersPath]];
    [tickerPicker show];
    [tickerPicker release];
}

#pragma mark -
#pragma mark TickerPicker Delegate

- (void)picker:(TickerPicker *)picker didPickAtIndex:(NSInteger)index
{
    NSArray * tickers = [NSArray arrayWithContentsOfFile:[[CommonTools pathForCachedTickers] stringByAppendingPathComponent:CachedTickersPath]];
    [_pickTickerButton setTitle:[tickers objectAtIndex:index] forState:UIControlStateNormal];
    
    _tradesDS = [[PrviateTradesDS alloc] initWithDelegate:self];
    [_tradesDS tradesForTicker:[tickers objectAtIndex:index]];
}


- (void)dataSourceFinishLoad:(PPQDataSource *)source
{
    [_tradeList removeAllObjects];
    [_tradeList addObjectsFromArray:[source.data valueForKey:@"trades"]];
    [_tradesDS release];_tradesDS = nil;
    
    CGFloat buyamount = 0.0;
    CGFloat buytradeCNY = 0.0;
    CGFloat sellamount = 0.0;
    CGFloat selltradeCNY = 0.0;
    
    for (NSDictionary *dic in _tradeList)
    {
        if ([[dic valueForKey:@"type"] compare:@"buy" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            buyamount += [[dic valueForKey:@"amount"] floatValue];
            buytradeCNY += [[dic valueForKey:@"amount"] floatValue] * [[dic valueForKey:@"rate"] floatValue];
        }
        else if ([[dic valueForKey:@"type"] compare:@"buy" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            sellamount += [[dic valueForKey:@"amount"] floatValue];
            selltradeCNY += [[dic valueForKey:@"amount"] floatValue] * [[dic valueForKey:@"rate"] floatValue];
        }
        else
        {
            //
        }
    }
    
    _buyAmountLabel.text = [NSString stringWithFormat:@"%.7f",buyamount];
    _buyCNYLabel.text = [NSString stringWithFormat:@"%.2f 人民币",buytradeCNY];
    _sellAmountLabel.text = [NSString stringWithFormat:@"%.7f",sellamount];
    _sellCNYLabel.text = [NSString stringWithFormat:@"%.2f 人民币",selltradeCNY];
    
    [_buyAmountLabel sizeToFit];
    [_buyCNYLabel sizeToFit];
    [_sellAmountLabel sizeToFit];
    [_sellCNYLabel sizeToFit];
    
    [_tableView reloadData];
}

- (void)dataSource:(PPQDataSource *)source hasError:(NSError *)error
{
    [_tradesDS release];_tradesDS = nil;
}

@end
