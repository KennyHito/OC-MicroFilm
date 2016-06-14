//
//  PlayerModel.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/27.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject

@property (nonatomic, strong)NSArray *cate;
@property (nonatomic, strong)NSDictionary *content;
@property (nonatomic, copy)NSString *intro;
@property (nonatomic, copy)NSString *publish_time;
@property (nonatomic, copy)NSString *rating;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *postid;

+ (PlayerModel *)createModelWithDic:(NSDictionary *)dict;

@end
