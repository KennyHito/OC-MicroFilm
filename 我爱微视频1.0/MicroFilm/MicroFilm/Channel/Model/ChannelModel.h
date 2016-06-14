//
//  ChannelModel.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelModel : NSObject

@property (nonatomic, copy)NSString *cateid;
@property (nonatomic, copy)NSString *catename;
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *alias;

+ (ChannelModel *)createModelWithDic:(NSDictionary *)dic;

@end
