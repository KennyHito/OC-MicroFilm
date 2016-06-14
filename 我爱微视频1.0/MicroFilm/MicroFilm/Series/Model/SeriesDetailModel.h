//
//  SeriesDetailModel.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/30.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeriesDetailModel : NSObject

@property (nonatomic, copy)NSString *thumbnail;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *series_postid;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *addtime;

+ (SeriesDetailModel *)createModelWithDic:(NSDictionary *)dict;

@end
