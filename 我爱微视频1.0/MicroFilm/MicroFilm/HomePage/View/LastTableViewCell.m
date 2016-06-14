//
//  LastTableViewCell.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/25.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "LastTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation LastTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}





- (void)loadDataWithModel:(LastModel *)model {
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"backImage.png"]];
    self.title.text = model.title;
    self.rating.text = model.rating;
    float star = [model.rating floatValue]/2;
    [self.starView setStarCount:star];
}

@end
