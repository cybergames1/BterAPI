//
//  ViewController.m
//  BterAPI
//
//  Created by jianting on 14/10/10.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "ViewController.h"
#import "ExchangeListDS.h"
#import "TickerCell.h"
#import "SingleTickerDS.h"
#import "CommonTools.h"
#import "TickerManager.h"
#import "LoadingButton.h"

#import "TickerDetailViewController.h"

@interface ViewController () <PPQDataSourceDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    UITableView * _tableView;
    
    NSMutableArray * _exchangeList;
    
    LoadingButton * _leftButton;
}

@property (nonatomic, retain) NSTimer * freshPriceTimer;
@property (nonatomic, retain) NSString * basicCoinName;

@end

@implementation ViewController

- (void)dealloc
{
    [_exchangeList release];_exchangeList = nil;
    [_freshPriceTimer release];_freshPriceTimer = nil;
    [_basicCoinName release];_basicCoinName = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self){
        self.title = @"行情";
        self.tabBarItem.title = @"行情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LoadingButton *leftButton = [LoadingButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 100, 44);
    _leftButton = leftButton;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = buttonItem;
    [buttonItem release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    _tableView = tableView;
    
    _exchangeList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *cachedTickersPath = [[CommonTools pathForCachedTickers] stringByAppendingPathComponent:CachedTickersPath];
    
    if ([CommonTools fileIfExist:cachedTickersPath])
    {
        NSArray *tickers = [NSArray arrayWithContentsOfFile:cachedTickersPath];
        
        for (NSString *title in tickers)
        {
            NSString *last = [title substringFromIndex:[title length] - 3];
            if ([last isEqualToString:@"cny"])
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
                [dic setObject:title forKey:@"tickerName"];
                [_exchangeList addObject:dic];
                [dic release];
                
                SingleTickerDS *stDataSource = [[SingleTickerDS alloc] initWithDelegate:self];
                stDataSource.requestType = title;
                [stDataSource tickerInfo:title];
            }
        }
    }
    else
    {
        ExchangeListDS *dataSource = [[ExchangeListDS alloc] initWithDelegate:self];
        dataSource.requestType = @"exchangeList";
        [dataSource getExchangeList];
        
        [_leftButton startLoading];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_freshPriceTimer invalidate];
    [_freshPriceTimer release];_freshPriceTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _freshPriceTimer = [[NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(refreshPrice) userInfo:nil repeats:YES] retain] ;
}

- (void)refreshPrice
{
    if ([_exchangeList count] > 0)
    {
        for (NSDictionary *dic in _exchangeList)
        {
            NSString *tickerName = [dic valueForKey:@"tickerName"];
            SingleTickerDS *stDataSource = [[SingleTickerDS alloc] initWithDelegate:self];
            stDataSource.requestType = tickerName;
            [stDataSource tickerInfo:tickerName];
        }
    }
}

- (void)leftButtonAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"交易币种对" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"对CNY交易",@"对BTC交易",@"对USD交易",@"新币观察区", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    [sheet release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBasicCoinName:(NSString *)basicCoinName
{
    if (_basicCoinName != basicCoinName)
    {
        [_basicCoinName release];
        _basicCoinName = [basicCoinName retain];
        
        [_leftButton setTitle:basicCoinName forState:UIControlStateNormal];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _exchangeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TickerCell";
    
    TickerCell *cell = (TickerCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[TickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    [cell resetCell];
    
    NSDictionary *dic = [_exchangeList objectAtIndex:indexPath.row];
    
    cell.tickerNameLabel.text = [dic valueForKey:@"tickerName"];
    cell.tickerPriceLabel.text = [dic valueForKey:@"tickerPrice"];
    cell.tickerPriceLabel.textColor = [dic valueForKey:@"tickerColor"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_exchangeList objectAtIndex:indexPath.row];
    
    TickerDetailViewController *controller = [[TickerDetailViewController alloc] init];
    controller.ticker = [dic valueForKey:@"tickerName"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];controller = nil;
}

#pragma mark -
#pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        self.basicCoinName = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

#pragma mark -
#pragma mark PPQDataSource Delegate

- (void)dataSourceFinishLoad:(PPQDataSource *)source
{
    if ([_exchangeList count] == 0)
    {
        NSString *cachedTickersPath = [[CommonTools pathForCachedTickers] stringByAppendingPathComponent:CachedTickersPath];
        [source.data writeToFile:cachedTickersPath atomically:YES];
        
        for (NSString *title in source.data)
        {
            NSString *last = [title substringFromIndex:[title length] - 3];
            if ([last isEqualToString:@"cny"])
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
                [dic setObject:title forKey:@"tickerName"];
                [_exchangeList addObject:dic];
                [dic release];
                
                SingleTickerDS *stDataSource = [[SingleTickerDS alloc] initWithDelegate:self];
                stDataSource.requestType = title;
                [stDataSource tickerInfo:title];
                
                [_leftButton stopLoading];
                self.basicCoinName = _basicCoinName;
            }
        }
    }
    else
    {
        for (NSMutableDictionary *dic in _exchangeList)
        {
            if ([[dic valueForKey:@"tickerName"] isEqualToString:source.requestType])
            {
                CGFloat lastPrice = [[dic valueForKey:@"tickerPrice"] floatValue];
                CGFloat newPrice = [[source.data valueForKey:@"last"] floatValue];
                
                [[TickerManager sharedManager] removeTicker:[[TickerManager sharedManager] tickerWithName:source.requestType]];
                
                MTicker *ticker = [[MTicker alloc] init];
                ticker.tickerName = [dic valueForKey:@"tickerName"];
                ticker.tickerPrice = newPrice;
                ticker.tickerHighPrice = [[source.data valueForKey:@"high"] floatValue];
                ticker.tickerLowPrice = [[source.data valueForKey:@"low"] floatValue];
                
                [[TickerManager sharedManager] addTicker:ticker];
                [ticker release];
                
                if (lastPrice > 0)
                {
                    if (newPrice > lastPrice) [dic setValue:Push_Color forKey:@"tickerColor"];
                    else if (newPrice < lastPrice) [dic setValue:Pull_Color forKey:@"tickerColor"];
                    else;
                }
                
                [dic setValue:[CommonTools stringValueForFloat:newPrice] forKey:@"tickerPrice"];
            }
        }
    }

    [source release];source = nil;
    
    [_tableView reloadData];
}

- (void)dataSource:(PPQDataSource *)source hasError:(NSError *)error
{
    NSLog(@"error");
    [source release];source = nil;
}

@end
