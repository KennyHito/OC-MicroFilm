//
//  PlayerViewController.h
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UIView *playView;
//@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (nonatomic, copy)NSString *postid;

@property(nonatomic,strong)AVPlayer *player;//播放器对象
@property(nonatomic,strong)AVPlayerItem *playerItem;// item



@end
