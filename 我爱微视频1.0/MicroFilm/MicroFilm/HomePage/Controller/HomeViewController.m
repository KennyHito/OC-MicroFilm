//
//  HomeViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "HomeViewController.h"
#import "Contents.h"
#import "HotViewController.h"
#import "ChannelViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIButton *lastBtn;
@property (nonatomic, strong)UIButton *hotBtn;
@property (nonatomic, strong)UIScrollView *scrollView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49)];
    _scrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT-64-49);
    [self.view addSubview:_scrollView];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    
    ChannelViewController *channel = [[ChannelViewController alloc]init];
    channel.view.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT-64-49);
    [self addChildViewController:channel];
    [_scrollView addSubview:channel.view];
    
    HotViewController *hot = [[HotViewController alloc]init];
    hot.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-49);
    [self addChildViewController:hot];
    [_scrollView addSubview:hot.view];
    
    UIView *titleview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH/2, 44)];
    self.navigationItem.titleView = titleview;
    
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _lastBtn.frame = CGRectMake(0, 5, WIDTH/5, 30);
    _hotBtn.frame = CGRectMake(WIDTH/2-WIDTH/5, 5, WIDTH/5, 30);
    
    [_lastBtn setTitle:@"最新" forState:UIControlStateNormal];
    [_hotBtn setTitle:@"频道" forState:UIControlStateNormal];
    
    [_lastBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_hotBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [_lastBtn addTarget:self action:@selector(lastBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_hotBtn addTarget:self action:@selector(hotBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _lastBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    [titleview addSubview:_lastBtn];
    [titleview addSubview:_hotBtn];
    
    _lastBtn.selected = NO;
    _hotBtn.selected = YES;
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44-2, WIDTH/5, 2)];
    _lineView.backgroundColor = [UIColor whiteColor];
    [titleview addSubview:_lineView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float x = _scrollView.contentOffset.x/WIDTH;
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.frame = CGRectMake(x * (WIDTH/2-WIDTH/5), 44-2, WIDTH/5, 2);
    }];
    if (x == 0) {
        _lastBtn.selected = NO;
        _hotBtn.selected = YES;
    } else if (x == 1) {
        _hotBtn.selected = NO;
        _lastBtn.selected = YES;
    }
    
}

- (void)lastBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.frame = CGRectMake(0, 44-2, WIDTH/5, 2);
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)hotBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.frame = CGRectMake(WIDTH/2-WIDTH/5, 44-2, WIDTH/5, 2);
        _scrollView.contentOffset = CGPointMake(WIDTH, 0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
