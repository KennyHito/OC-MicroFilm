//
//  SeriesModel.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeriesModel : NSObject

@property (nonatomic, copy)NSString *app_image;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *follower_num;
@property (nonatomic, copy)NSString *seriesid;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *update_to;

+ (SeriesModel *)createModelWithDic:(NSDictionary *)dic;

@end
