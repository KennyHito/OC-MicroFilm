//
//  Contents.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/24.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#ifndef Contents_h
#define Contents_h

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

//首页
//最新
#define LastURL @"http://app.vmoiver.com/apiv3/post/getPostByTab?p=%d&tab=hot"
//最新滚动头视图
#define HeaderURL @"http://app.vmoiver.com/apiv3/index/getBanner/"
//热门
#define HotURL @"http://app.vmoiver.com/apiv3/post/getPostByTab?p=%d&tab=latest"
//首页详情
#define HomeDetailURL @"http://app.vmoiver.com/apiv3/post/view?postid=%@" //postid(NSString)
#define LastWebUrl @"http://app.vmoiver.com/%@?qingapp=app_new&debug=1"

//频道
#define ChannelURL @"http://app.vmoiver.com/apiv3/cate/getList"
//各个频道
#define ChannelEachURL @"http://app.vmoiver.com/apiv3/post/getPostInCate?cateid=%@&p=%d" //cateid (NSString)

//系列
#define SeriesURL @"http://app.vmoiver.com/apiv3/series/getList?p=%d"
#define seriesDetailUrl @"http://app.vmoiver.com/apiv3/series/view?seriesid=%@"
#define SeriesMp4Url @"http://app.vmoiver.com/apiv3/series/getVideo?series_postid=%@"



#define BehindNavURL @"http://app.vmoiver.com/apiv3/backstage/getPostByCate?cateid=47&p=%d"

#define BehindURL @"http://app.vmoiver.com/apiv3/backstage/getPostByCate?cateid=%@&p=%d"//cateid

#endif /* Contents_h */
