//
//  ViewController.m
//  HJHoverTable
//
//  Created by WHJ on 2018/8/8.
//  Copyright © 2018年 WHJ. All rights reserved.
//
#import "HJHoverTable.h"
#import "ViewController.h"
#import <Masonry/Masonry.h>


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,HJHoverTableDelegate>

@property (nonatomic , strong) HJHoverTable *hoverTable;

@end

static const CGFloat ORIGIN_TOP = 120.f;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hoverTable = [[HJHoverTable alloc] init];
    self.hoverTable.hoverTableDelegate = self;
    self.hoverTable.tableDelegate = self;
    self.hoverTable.tableDataSource = self;
    [self.view addSubview:self.hoverTable];
    
    [self.hoverTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ORIGIN_TOP);
        make.left.bottom.right.mas_equalTo(0);
    }];

    [self.hoverTable reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HJHoverTableDelegate
- (UIView *)headerOfHoverTable
{
    //自定义header样式
    UIImageView *headerView = [UIImageView new];
    headerView.image = [UIImage imageNamed:@"pic3.jpg"];
    return headerView;
}

- (CGFloat)headerHOfHoverTable
{
    return ORIGIN_TOP;
}

//自定义table样式
- (HJGestureTable *)gestureTable
{
    HJGestureTable *table = [[HJGestureTable alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.backgroundColor = [UIColor grayColor];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    return table;
}

- (HJTopLimit)limitOfMarginTop
{
    return HJTopLimitMake(ORIGIN_TOP,0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.backgroundColor = [UIColor yellowColor];
    cell.textLabel.text = [NSString stringWithFormat:@"简单的标题%zd号",indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

@end
