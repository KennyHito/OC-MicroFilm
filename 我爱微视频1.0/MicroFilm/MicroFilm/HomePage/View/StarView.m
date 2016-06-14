//
//  StarView.m
//  LimitFree
//
//  Created by 寇汉卿 on 16/3/16.
//  Copyright © 2016年 wangqiang. All rights reserved.
//

#import "StarView.h"

@implementation StarView
{
    UIImageView *_backgroundImageView;
    UIImageView *_foregroundImageView;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIImage *backgroudImage = [UIImage imageNamed:@"StarsBackground"];
        _backgroundImageView = [[UIImageView alloc]initWithImage:backgroudImage];
        _backgroundImageView.frame = CGRectMake(0, 0, backgroudImage.size.width, backgroudImage.size.height);
        [self addSubview:_backgroundImageView];
        
        //加载红五星
        UIImage *foregroundImage = [UIImage imageNamed:@"StarsForeground"];
        _foregroundImageView = [[UIImageView alloc]initWithImage:foregroundImage];
        _foregroundImageView.frame = CGRectMake(0, 0, foregroundImage.size.width, foregroundImage.size.height);
        [self addSubview:_foregroundImageView];
        
        _backgroundImageView.contentMode = UIViewContentModeLeft;
        
        //这两个属性组起来的作用就是图片在UIImageView里靠左显示且不自动缩放，如果frame的宽度小于图片的宽度，图片超出的部分会被剪掉
        _foregroundImageView.contentMode = UIViewContentModeLeft;
        _foregroundImageView.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//显示几颗星
- (void)setStarCount:(CGFloat)starCount
{
    //根据starCount/5*图片的原始宽度作为红星的宽度
    CGFloat width = starCount/5*_backgroundImageView.frame.size.width;
    _foregroundImageView.frame = CGRectMake(0, 0, width, _foregroundImageView.frame.size.height);
}

@end
