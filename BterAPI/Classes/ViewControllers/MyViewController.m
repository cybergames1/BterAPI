//
//  MyViewController.m
//  BterAPI
//
//  Created by jianting on 14/10/11.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "MyViewController.h"
#import "FundsViewController.h"
#import "TradesViewController.h"
#import "OrderListViewController.h"

@interface MyViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _myList;
}

@end

@implementation MyViewController

- (void)dealloc
{
    [_myList release];_myList = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _myList = [[NSArray arrayWithObjects:@"我的资金",@"我的挂单",@"成交记录", nil] retain];
        
        self.title = @"我的";
        self.tabBarController.tabBarItem.title = @"我的";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myidentifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myidentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myidentifier] autorelease];
    }
    
    cell.textLabel.text = [_myList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //资金
            FundsViewController *controller = [[FundsViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case 1:
        {
            //挂单
            OrderListViewController *controller = [[OrderListViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case 2:
        {
            //交易记录
            TradesViewController *controller = [[TradesViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        default:
            break;
    }
}
@end
