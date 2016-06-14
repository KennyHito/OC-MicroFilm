//
//  SeriesPlayerController.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/30.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SeriesPlayerController : UIViewController

@property (nonatomic, copy)NSString *postid;

@property(nonatomic,strong)AVPlayer *player;//播放器对象
@property(nonatomic,strong)AVPlayerItem *playerItem;// item

@end
