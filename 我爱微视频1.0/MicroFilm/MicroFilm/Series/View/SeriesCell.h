//
//  SeriesCell.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeriesModel.h"

@interface SeriesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *updateText;
@property (weak, nonatomic) IBOutlet UILabel *contentText;

- (void)createCellWithModel:(SeriesModel *)model;

@end
