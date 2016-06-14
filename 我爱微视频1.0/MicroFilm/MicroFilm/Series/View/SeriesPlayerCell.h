//
//  SeriesPlayerCell.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/6/1.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeriesPlayerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
