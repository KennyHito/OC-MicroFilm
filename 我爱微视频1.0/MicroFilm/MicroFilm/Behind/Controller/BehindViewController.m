//
//  BehindViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "BehindViewController.h"
#import "Contents.h"
#import "LastTableViewCell.h"
#import "FavouriteManager.h"
#import "LastModel.h"
#import "PlayerViewController.h"

@interface BehindViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UILabel *label;

@end

@implementation BehindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [[NSMutableArray alloc]init];
    [self customUI];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareData];
}

- (void)prepareData {
    [_dataArr removeAllObjects];
    for (NSDictionary *dic in [[FavouriteManager defaultManager]allFavorited]) {
        LastModel *model = [LastModel createModelWithDic:dic];
        [_dataArr addObject:model];
    }
    if (_dataArr.count <= 0) {
        _label.alpha = 1;
    } else {
        _label.alpha = 0;
    }
    [_tableView reloadData];
}


- (void)customUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"LastTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, WIDTH, 100)];
    _label.text = @"您还没收藏任何作品...";
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    _label.alpha = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArr.count <= 0) {
        return cell;
    }
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

@end
