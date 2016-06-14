//
//  HeaderViewController.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/31.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
