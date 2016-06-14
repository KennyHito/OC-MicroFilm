//
//  LastModel.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/25.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "LastModel.h"

@implementation LastModel

+ (LastModel *)createModelWithDic:(NSDictionary *)dic {
    LastModel *model = [[LastModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}



@end

@implementation HeaderModel

+ (HeaderModel *)createModelWithDic:(NSDictionary *)dic {
    HeaderModel *model = [[HeaderModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
