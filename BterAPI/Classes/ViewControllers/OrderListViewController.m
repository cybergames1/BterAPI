//
//  OrderListViewController.m
//  BterAPI
//
//  Created by jianting on 14/10/13.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "OrderListViewController.h"
#import "PrivateOrderListDS.h"
#import "MyTradesCell.h"
#import "CommonTools.h"
#import "UIView+Addition.h"

@interface OrderListViewController () <UITableViewDataSource,UITableViewDelegate,PPQDataSourceDelegate>
{
    UITableView * _tableView;
    PrivateOrderListDS * _orderListDS;
    NSMutableArray * _orderList;
}

@end

@implementation OrderListViewController

- (void)dealloc
{
    if (_orderListDS)
    {
        [_orderListDS cancelAllRequest];
        _orderListDS.delegate = nil;
        [_orderListDS release];_orderListDS = nil;
    }
    [_orderList release];_orderList = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _orderList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的挂单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    _tableView = tableView;
    
    _orderListDS = [[PrivateOrderListDS alloc] initWithDelegate:self];
    [_orderListDS orderList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tradeidentifier = @"TradesCell";
    
    MyTradesCell *cell = [tableView dequeueReusableCellWithIdentifier:tradeidentifier];
    if (cell == nil)
    {
        cell = [[[MyTradesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tradeidentifier] autorelease];
        for (UILabel *label in cell.contentView.subviews)
        {
            label.left -= 80;
        }
    }
    
    [cell resetCell];
    
    NSDictionary *dic = [_orderList objectAtIndex:indexPath.row];
    
    cell.tradeDateLabel.width = 0;
    cell.tradeTypeLabel.text = [dic valueForKey:@"type"];
    cell.tradeNameLabel.text = [[dic valueForKey:@"type"] isEqualToString:@"buy"] ? [dic valueForKey:@"buy_type"] : [dic valueForKey:@"sell_type"];
    cell.tradePriceLabel.text = [CommonTools stringValue:[dic valueForKey:@"rate"]];
    cell.tradeAmountLabel.text = [[dic valueForKey:@"type"] isEqualToString:@"buy"] ? [dic valueForKey:@"buy_amount"] : [dic valueForKey:@"sell_amount"];
    cell.tradeCNYLabel.text = [CommonTools stringValueForFloat:[cell.tradePriceLabel.text floatValue] * [cell.tradeAmountLabel.text floatValue]];
    [cell setIsBuy:[cell.tradeTypeLabel.text compare:@"buy" options:NSCaseInsensitiveSearch] == NSOrderedSame];
    
    return cell;
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
    [_orderList removeAllObjects];
    [_orderList addObjectsFromArray:[source.data valueForKey:@"orders"]];
    [_orderListDS release];_orderListDS = nil;
    [_tableView reloadData];
}

- (void)dataSource:(PPQDataSource *)source hasError:(NSError *)error
{
    [_orderListDS release];_orderListDS = nil;
}


@end
