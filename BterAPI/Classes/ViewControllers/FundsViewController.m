//
//  FundsViewController.m
//  BterAPI
//
//  Created by jianting on 14/10/12.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "FundsViewController.h"
#import "PrivateFundsDS.h"
#import "UIView+Addition.h"
#import "MyFundsCell.h"
#import "TickerManager.h"
#import "CommonTools.h"

@interface FundsViewController () <PPQDataSourceDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PrivateFundsDS * _fundsDS;
    
    NSMutableArray * _availableFundsList;
    NSMutableArray * _lockedFundsList;
    
    NSMutableArray * _tableDataList;
    
    UITableView * _tableView;
    UISegmentedControl * _segmentedControl;
    
    UILabel * _amountCNYLabel;
    UILabel * _availableCNYLabel;
    UILabel * _lockedCNYLabel;
}

@end

@implementation FundsViewController

- (void)dealloc
{
    if (_fundsDS)
    {
        [_fundsDS cancelAllRequest];
        _fundsDS.delegate = nil;
        [_fundsDS release];_fundsDS = nil;
    }
    
    [_availableFundsList release];_availableFundsList = nil;
    [_lockedFundsList release];_lockedFundsList = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _availableFundsList = [[NSMutableArray alloc] initWithCapacity:0];
        _lockedFundsList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的资金";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTotalFundView];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"可用资产",@"锁定资产", nil]];
    [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    [segmentedControl release];
    _segmentedControl = segmentedControl;
    [segmentedControl setFrame:CGRectMake((self.view.width - 250)/2, _lockedCNYLabel.bottom + 10, 250, 40)];
    segmentedControl.selectedSegmentIndex = 0;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.top = segmentedControl.bottom + 10;
    tableView.height -= tableView.top + self.tabBarController.tabBar.height;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    _tableView = tableView;
    
    _fundsDS = [[PrivateFundsDS alloc] initWithDelegate:self];
    [_fundsDS funds];
}

- (void)setTotalFundView
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(15, 64 + 10, 0, 0)] autorelease];
    label.text = @"资金估计";
    label.font = [UIFont systemFontOfSize:13];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _amountCNYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 0, 0)] autorelease];
    _amountCNYLabel.backgroundColor = [UIColor clearColor];
    _amountCNYLabel.text = @"0 人民币";
    _amountCNYLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_amountCNYLabel];
    [_amountCNYLabel sizeToFit];
    
    label = [[[UILabel alloc] initWithFrame:CGRectMake(15, label.bottom + 5, 0, 0)] autorelease];
    label.text = @"可用资金";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _availableCNYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 0, 0)] autorelease];
    _availableCNYLabel.backgroundColor = [UIColor clearColor];
    _availableCNYLabel.text = @"0 人民币";
    _availableCNYLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:_availableCNYLabel];
    [_availableCNYLabel sizeToFit];
    
    label = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 85, label.top, 0, 0)] autorelease];
    label.text = @"锁定资金";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _lockedCNYLabel = [[[UILabel alloc] initWithFrame:CGRectMake(label.right + 5, label.top, 0, 20)] autorelease];
    _lockedCNYLabel.backgroundColor = [UIColor clearColor];
    _lockedCNYLabel.text = @"0 人民币";
    _lockedCNYLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:_lockedCNYLabel];
    [_lockedCNYLabel sizeToFit];
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

- (void)segmentedControlAction:(UISegmentedControl *)segmentedControl
{
    _tableDataList = segmentedControl.selectedSegmentIndex ? _lockedFundsList : _availableFundsList;
    [_tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fundidentifier = @"FundsCell";
    
    MyFundsCell *cell = [tableView dequeueReusableCellWithIdentifier:fundidentifier];
    if (cell == nil)
    {
        cell = [[[MyFundsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fundidentifier] autorelease];
    }
    
    [cell resetCell];
    
    NSDictionary *dic = [_tableDataList objectAtIndex:indexPath.row];
    NSString *tickerName = [NSString stringWithFormat:@"%@_cny",[dic valueForKey:@"TickerName"]];
    
    cell.tickerNameLabel.text = [dic valueForKey:@"TickerName"];
    cell.tickerAmountLabel.text = [dic valueForKey:@"TickerAmount"];
    cell.tickerCNYLabel.text = [CommonTools stringValueForFloat:[[TickerManager sharedManager] tickerWithName:tickerName].tickerPrice * [cell.tickerAmountLabel.text floatValue]];
    
    return cell;
}


- (void)dataSourceFinishLoad:(PPQDataSource *)source
{
    NSDictionary *availableDic = [source.data valueForKey:@"available_funds"];
    NSArray *keys = [[availableDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    CGFloat fund = 0.0;
    
    for (NSString *key in keys)
    {
        if ([key compare:@"CNY" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            _availableCNYLabel.text = [NSString stringWithFormat:@"%.2f 人民币",[[availableDic valueForKey:key] floatValue]];
            [_availableCNYLabel sizeToFit];
            fund += [[availableDic valueForKey:key] floatValue];
        }
        else
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
            [dic setValue:key forKey:@"TickerName"];
            [dic setValue:[availableDic valueForKey:key] forKey:@"TickerAmount"];
            [_availableFundsList addObject:dic];
            [dic release];
            
            NSString *tickerName = [NSString stringWithFormat:@"%@_cny",key];
            fund += [[TickerManager sharedManager] tickerWithName:tickerName].tickerPrice * [[availableDic valueForKey:key] floatValue];
        }
    }
    
    NSDictionary *lockedDic = [source.data valueForKey:@"locked_funds"];
    keys = [lockedDic allKeys];
    
    
    for (NSString *key in keys)
    {
        if ([key compare:@"CNY" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            _lockedCNYLabel.text = [NSString stringWithFormat:@"%.2f 人民币",[[lockedDic valueForKey:key] floatValue]];
            [_lockedCNYLabel sizeToFit];
            fund += [[lockedDic valueForKey:key] floatValue];
        }
        else
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
            [dic setValue:key forKey:@"TickerName"];
            [dic setValue:[lockedDic valueForKey:key] forKey:@"TickerAmount"];
            [_lockedFundsList addObject:dic];
            [dic release];
            
            NSString *tickerName = [NSString stringWithFormat:@"%@_cny",key];
            fund += [[TickerManager sharedManager] tickerWithName:tickerName].tickerPrice * [[lockedDic valueForKey:key] floatValue];
        }
    }
    
    _amountCNYLabel.text = [NSString stringWithFormat:@"%.2f 人民币",fund];
    [_amountCNYLabel sizeToFit];
    
    [self segmentedControlAction:_segmentedControl];
    
    [_fundsDS release];_fundsDS = nil;
}

- (void)dataSource:(PPQDataSource *)source hasError:(NSError *)error
{
    [_fundsDS release];_fundsDS = nil;
}

@end
