//
//  HotViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "HotViewController.h"
#import "Contents.h"
#import "LastModel.h"
#import "LastTableViewCell.h"
#import "PlayerViewController.h"
#import "SDCycleScrollView.h"
#import "HttpRequest.h"
#import "SVProgressHUD.h"

@interface HotViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSMutableArray *headerArr;
@property (nonatomic, strong)NSMutableArray *headerArray;

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dataArr = [[NSMutableArray alloc]init];
    _headerArr = [[NSMutableArray alloc]init];
    _headerArray = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"LastTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [self prepareData];
    
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

//头视图滚动视图
- (void)createHeaderView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/16*9) delegate:self placeholderImage:[UIImage imageNamed:@"backImage.png"]];
    }
    
    
    self.tableView.tableHeaderView = _cycleScrollView;
    
    //滚动视图点点样式
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollView.imageURLStringsGroup = _headerArr;
    });
}

//头视图图片点击方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%lu", index);
    PlayerViewController *player = [[PlayerViewController alloc]init];
    HeaderModel *model = _headerArray[index];
    player.hidesBottomBarWhenPushed = YES;
    NSArray *components = [model.extra componentsSeparatedByString:@":"];
    NSString *str = components[2];
    NSString *str2 = [str substringWithRange:NSMakeRange(1, str.length-3)];
    player.postid = str2;
    [self.navigationController pushViewController:player animated:YES];
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


- (void)prepareData {
    [_headerArr removeAllObjects];
    //滚动视图数据下载
    [HttpRequest requestHttpWithUrl:HeaderURL AndReturnBlock:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSArray *array = data[@"data"];
            for (NSDictionary *dic in array) {
                HeaderModel *model = [HeaderModel createModelWithDic:dic];
                [_headerArray addObject:model];
                [_headerArr addObject:model.image];
            }
            [_headerArray removeObjectAtIndex:1];
            [_headerArr removeObjectAtIndex:1];
            [_headerArray removeObjectAtIndex:2];
            [_headerArr removeObjectAtIndex:2];
            [self createHeaderView];
        }
    }];
    
    
    NSString *url = [NSString stringWithFormat:HotURL, _page];
    [HttpRequest requestHttpWithUrl:url AndReturnBlock:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSArray *array = data[@"data"];
            for (NSDictionary *dic in array) {
                LastModel *model = [LastModel createModelWithDic:dic];
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
