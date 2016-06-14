//
//  LastTableViewCell.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/25.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LastModel.h"
#import "StarView.h"

@interface LastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet StarView *starView;




- (void)loadDataWithModel:(LastModel *)model;

@end
