//
//  LastModel.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/25.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LastModel : NSObject

@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *publish_time;
@property (nonatomic, copy)NSString *rating;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *postid;

+ (LastModel *)createModelWithDic:(NSDictionary *)dic;

@end

@interface HeaderModel : NSObject

@property (nonatomic, copy)NSString *bannerid;
@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *extra;

+ (HeaderModel *)createModelWithDic:(NSDictionary *)dic;

@end
