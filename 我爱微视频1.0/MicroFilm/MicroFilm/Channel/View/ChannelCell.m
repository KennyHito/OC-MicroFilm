//
//  ChannelCell.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "ChannelCell.h"
#import "UIImageView+WebCache.h"

@implementation ChannelCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)createCellWithModel:(ChannelModel *)model {
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"backImage.png"]];
    self.cateName.text = [NSString stringWithFormat:@"#%@#", model.catename];
    self.alias.text = [NSString stringWithFormat:@"%@", model.alias];
}

@end
