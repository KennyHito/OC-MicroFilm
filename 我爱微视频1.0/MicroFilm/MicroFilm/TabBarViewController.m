//
//  TabBarViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "ChannelViewController.h"
#import "SeriesViewController.h"
#import "BehindViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    
    HomeViewController *home = [[HomeViewController alloc]init];
    SeriesViewController *series = [[SeriesViewController alloc]init];
    BehindViewController *behind = [[BehindViewController alloc]init];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:home, series, behind, nil];
    NSArray *selectedArr = @[@"tabBar_first32", @"tabBar_category32", @"tabBar_back32"];
    NSArray *normalArr = @[@"tabBar_first_select32", @"tabBar_gategory_select32", @"tabBar_back_select32"];
    NSArray *titleArr = @[@"首页", @"系列", @"收藏"];
    for (int i = 0; i < array.count; i++) {
        //一侧得到每个视图控制器
        UIViewController *vc = array[i];
        //vc-->navc
        UINavigationController *navc= [[UINavigationController alloc]initWithRootViewController:vc];
        //设置标题
        vc.title = titleArr[i];
        //渲染模式 （保证图片样式不更改）
        UIImage *normalImage = [UIImage imageNamed:normalArr[i]];
        UIImage *selectedImage = [UIImage imageNamed:selectedArr[i]];
        //替换 将array数组中的vc-->navc
        [array replaceObjectAtIndex:i withObject:navc];
        //设置状态图片
        navc.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];   
    }
    
    self.viewControllers = array;
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
