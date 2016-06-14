//
//  SeriesCell.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "SeriesCell.h"
#import "UIImageView+WebCache.h"

@implementation SeriesCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)createCellWithModel:(SeriesModel *)model {
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.app_image] placeholderImage:[UIImage imageNamed:@"backImage.png"]];
    self.title.text = model.title;
    self.updateText.text = [NSString stringWithFormat:@"已更新至%@集", model.update_to];
    self.contentText.text = model.content;
}

@end
