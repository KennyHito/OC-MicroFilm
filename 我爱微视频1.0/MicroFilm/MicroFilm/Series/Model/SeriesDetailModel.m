//
//  SeriesDetailModel.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/30.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "SeriesDetailModel.h"

@implementation SeriesDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (SeriesDetailModel *)createModelWithDic:(NSDictionary *)dict {
    SeriesDetailModel *model = [[SeriesDetailModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}


@end

