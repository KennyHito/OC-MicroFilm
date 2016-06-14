//
//  ChannelViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "ChannelViewController.h"
#import "Contents.h"
#import "ChannelModel.h"
#import "ChannelCell.h"
#import "LastViewController.h"
#import "HttpRequest.h"

@interface ChannelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collection;
@property (nonatomic, strong)NSMutableArray *dataArr;


@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    [self prepareData];
    [self refresh];
}

- (void)createUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) collectionViewLayout:layout];
    _collection.showsVerticalScrollIndicator = NO;
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [_collection registerNib:[UINib nibWithNibName:@"ChannelCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collection];
}

- (void)refresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArr removeAllObjects];
        [self prepareData];
        [self.collection.header endRefreshing];
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新，请稍等" forState:MJRefreshStateRefreshing];
    
    self.collection.header = header;
    

}

- (void)prepareData {
    
    [HttpRequest requestHttpWithUrl:ChannelURL AndReturnBlock:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSArray *arr = data[@"data"];
            for (NSDictionary *dict in arr) {
                ChannelModel *model = [ChannelModel createModelWithDic:dict];
                [_dataArr addObject:model];
            }
            [self.collection reloadData];
        }
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArr.count <= 0) {
        return cell;
    }
    ChannelModel *model = _dataArr[indexPath.row];
    [cell createCellWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = WIDTH/2;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelModel *model = _dataArr[indexPath.row];
    LastViewController *detail = [[LastViewController alloc]init];
    detail.cateid = model.cateid;
    detail.titles = model.catename;
    [self.navigationController pushViewController:detail animated:YES];
}


@end
