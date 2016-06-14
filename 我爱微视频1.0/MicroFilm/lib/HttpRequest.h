//
//  HttpRequest.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/6/2.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface HttpRequest : NSObject

+ (void)requestHttpWithUrl:(NSString *)url AndReturnBlock:(void(^)(NSDictionary *data, NSError *error))block;

@end
