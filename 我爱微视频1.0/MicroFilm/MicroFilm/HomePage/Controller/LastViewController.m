//
//  LastViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "LastViewController.h"
#import "Contents.h"
#import "LastModel.h"
#import "LastTableViewCell.h"
#import "PlayerViewController.h"
#import "StarView.h"
#import "HttpRequest.h"
#import "SVProgressHUD.h"



@interface LastViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)int page;

@end

@implementation LastViewController

- (void)viewDidLoad {
    self.title = _titles;
    [super viewDidLoad];
    _page = 1;
    _dataArr = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LastTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"cell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [self prepareTableData];
    [self refresh];
}




//刷新
- (void)refresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArr removeAllObjects];
        _page = 1;
        [self prepareTableData];

        [self.tableView.header endRefreshing];
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新，等着" forState:MJRefreshStateRefreshing];
    
    self.tableView.header = header;
    
    //上拉加载更多
    //请求下一页的数据
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self prepareTableData];
        [self.tableView.footer endRefreshing];
    }];
    
    [footer setTitle:@"上拉加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新，等着" forState:MJRefreshStateRefreshing];
    
    self.tableView.footer = footer;
}

- (void)prepareTableData {
    
    
    NSString *url = [NSString stringWithFormat:ChannelEachURL, _cateid, _page];

    
    [HttpRequest requestHttpWithUrl:url AndReturnBlock:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSArray *array = data[@"data"];
            for (NSDictionary *dict in array) {
                LastModel *model = [LastModel createModelWithDic:dict];
                [_dataArr addObject:model];
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    }];
    
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArr.count <= 0) {
        return cell;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LastModel *model = _dataArr[indexPath.row];
    [cell loadDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerViewController *player = [[PlayerViewController alloc]init];
    LastModel *model = _dataArr[indexPath.row];
    player.hidesBottomBarWhenPushed = YES;
    player.postid = model.postid;
    [self.navigationController pushViewController:player animated:YES];
}

@end
