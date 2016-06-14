//
//  SeriesModel.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "SeriesModel.h"

@implementation SeriesModel

+ (SeriesModel *)createModelWithDic:(NSDictionary *)dic {
    SeriesModel *model = [[SeriesModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
