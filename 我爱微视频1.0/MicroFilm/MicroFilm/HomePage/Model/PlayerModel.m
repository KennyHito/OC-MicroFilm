//
//  PlayerModel.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/27.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "PlayerModel.h"

@implementation PlayerModel

+ (PlayerModel *)createModelWithDic:(NSDictionary *)dict {
    PlayerModel *model = [[PlayerModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
