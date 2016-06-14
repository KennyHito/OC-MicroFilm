//
//  FavouriteManager.m
//  Comics
//
//  Created by 寇汉卿 on 16/4/6.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "FavouriteManager.h"
#import "FMDatabase.h"

FavouriteManager *manager = nil;

@implementation FavouriteManager
{
    FMDatabase *_fmdb;
}

- (id)init
{
    if (self = [super init]) {
        NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/favouriterr.db"];
        _fmdb = [[FMDatabase alloc]initWithPath:dbPath];
        NSLog(@"%@", dbPath);
        [_fmdb open];
        //图片网址，作者名，标题，id
        NSString *sql = @"create table if not exists favorite(imageUrl varchar(1000), title varchar(1000), favoriteID varchar(100), star varchar(50), pushWich varchar(50))";
        [_fmdb executeUpdate:sql];
    }
    return self;
}

+(FavouriteManager *)defaultManager//单例
{
    if ((!manager)) {
        manager = [[FavouriteManager alloc]init];
    }
    return manager;
}

- (void)favouriteWithDetail:(NSArray *)array
{
    NSString *sql = @"insert into favorite(imageUrl, title, favoriteID, star, pushWich) values(?,?,?,?,?)";
    BOOL isSuccess = [_fmdb executeUpdate:sql, array[0], array[1], array[2], array[3], array[4]];
    if (isSuccess) {
        NSLog(@"数据增加成功");
    } else {
        NSLog(@"数据增加失败");
    }
}

- (BOOL)isFavorited:(NSString *)favoriteID
{
    NSString *sql = @"select * from favorite where favoriteID=?";
    FMResultSet *result = [_fmdb executeQuery:sql, favoriteID];
    if (result.next) {
        return YES;
    }
    return NO;
}

//取消收藏
- (void)cancelWithfavoriteNum:(NSString *)favoriteNum
{
    NSString *sql = @"delete from favorite where favoriteID=?";
    [_fmdb executeUpdate:sql, favoriteNum];
}

- (NSArray *)allFavorited
{
    NSString *sql = @"select * from favorite";
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *result = [_fmdb executeQuery:sql];
    while ([result next]) {
        NSString *imageUrl = [result stringForColumn:@"imageUrl"];
        NSString *title = [result stringForColumn:@"title"];
        NSString *favoriteID = [result stringForColumn:@"favoriteID"];
        NSString *star = [result stringForColumn:@"star"];
        NSString *pushWich = [result stringForColumn:@"pushWich"];
        NSDictionary *dic = @{@"image":imageUrl, @"title":title, @"postid":favoriteID, @"rating":star, @"pushWich":pushWich};
        [array addObject:dic];
        
    }
    return array;
}




@end
