//
//  SeriesViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "SeriesViewController.h"
#import "Contents.h"
#import "SeriesCell.h"
#import "SeriesModel.h"
#import "SeriesPlayerController.h"
#import "HttpRequest.h"
#import "SVProgressHUD.h"

@interface SeriesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)int page;

@end

@implementation SeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dataArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createUI];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [self prepareData];
    [self refresh];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)createUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"SeriesCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (void)prepareData {
    NSString *url = [NSString stringWithFormat:SeriesURL, _page];
    
    [HttpRequest requestHttpWithUrl:url AndReturnBlock:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSArray *array = data[@"data"];
            for (NSDictionary *dict in array) {
                SeriesModel *model = [SeriesModel createModelWithDic:dict];
                [_dataArr addObject:model];
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)refresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArr removeAllObjects];
        
        _page = 1;
        [self prepareData];
        [self.tableView.header endRefreshing];
        
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新，等着" forState:MJRefreshStateRefreshing];
    
    self.tableView.header = header;
    
    //上拉加载更多
    //请求下一页的数据
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self prepareData];
        [self.tableView.footer endRefreshing];
    }];
    
    [footer setTitle:@"上拉加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新，等着" forState:MJRefreshStateRefreshing];
    
    self.tableView.footer = footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SeriesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArr.count <= 0) {
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SeriesModel *model = _dataArr[indexPath.row];
    [cell createCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SeriesPlayerController *player = [[SeriesPlayerController alloc]init];
    player.hidesBottomBarWhenPushed = YES;
    SeriesModel *model = _dataArr[indexPath.row];
    player.postid = model.seriesid;
    [self.navigationController pushViewController:player animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
