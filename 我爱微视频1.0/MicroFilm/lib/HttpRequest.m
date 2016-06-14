//
//  HttpRequest.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/6/2.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "HttpRequest.h"


@implementation HttpRequest

+ (void)requestHttpWithUrl:(NSString *)url AndReturnBlock:(void(^)(NSDictionary *data, NSError *error))block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil, error);
    }];
    
}

@end
