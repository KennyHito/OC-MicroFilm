//
//  FavouriteManager.h
//  Comics
//
//  Created by 寇汉卿 on 16/4/6.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavouriteManager : NSObject

- (void)favouriteWithDetail:(NSArray *)array;
- (BOOL)isFavorited:(NSString *)favoriteNum;
- (void)cancelWithfavoriteNum:(NSString *)favoriteNum;//取消收藏
- (NSArray *)allFavorited;

+ (FavouriteManager *)defaultManager;
@end
