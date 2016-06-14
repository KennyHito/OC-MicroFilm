//
//  PlayerViewController.m
//  MicroFilm
//
//  Created by 寇汉卿 on 16/5/26.
//  Copyright © 2016年 kouhanqing. All rights reserved.
//

#import "PlayerViewController.h"
#import "Contents.h"
#import "PlayerModel.h"
#import "AppDelegate.h"
#import "HttpRequest.h"
#import "FavouriteManager.h"


@interface PlayerViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIView *playView; //播放容器
@property (nonatomic, strong)UIView *progressView;//透明视图
@property (nonatomic, strong)UIView *controlView;//半透明视图

@property (nonatomic, strong)UIButton *buttonPlay;//播放按钮
@property (nonatomic, strong)UIButton *buttonScreen;//全屏按钮
@property (nonatomic, strong)UIProgressView *progressLine;//进度条
@property (nonatomic, strong)UISlider*slider;//播放进度
@property (nonatomic, strong)NSString *mp4Url;
@property (nonatomic, strong)AVPlayerLayer *playerLayer;
@property (nonatomic, strong)UILabel *labelTime;//视频的时间
@property (nonatomic, assign)CGFloat totalMovieDuration;//当前视频的总时长

@property (nonatomic, copy)NSString *totalTime;

@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)BOOL isalpha;

@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, copy)NSString *strUrl;

@property (nonatomic, assign)NSTimeInterval totalBuffer;

@property (nonatomic, strong)NSMutableArray *favouriteArr;

@property (nonatomic, strong)UIActivityIndicatorView *webActive;
@property (nonatomic, strong)UIActivityIndicatorView *mp4Active;

@end

@implementation PlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _favouriteArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉黑线
    
    //收藏按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setImage:[UIImage imageNamed:@"favourite32.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"favourite_select.png"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(favouriteClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    BOOL isFav = [[FavouriteManager defaultManager]isFavorited:_postid];
    if (isFav == YES) {
        btn.selected = YES;
    } else {
        btn.selected = NO;
    }

    [self webData];
    [self prepareData];
}
- (void)favouriteClick:(UIButton *)sender {
    if (_favouriteArr.count != 0) {
        if (sender.selected == YES) {
            [[FavouriteManager defaultManager]cancelWithfavoriteNum:_postid];
            sender.selected = NO;
        } else if (sender.selected == NO) {
            [[FavouriteManager defaultManager]favouriteWithDetail:_favouriteArr];
            sender.selected = YES;
        }
        
    }
}

#pragma mark -- 设置
- (void)setUpPlayer{
    //主要实现 设置进度条的进度 以及显示当前播放时间
    
    
    __weak __typeof(self)weakSelf = self;
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //获取总时间
        float totalTime = weakSelf.player.currentItem.duration.value*1.0/weakSelf.player.currentItem.duration.timescale;
        
        //获取当前时间
        float currentTime = weakSelf.player.currentItem.currentTime.value*1.0/weakSelf.player.currentTime.timescale;
        
        //设置进度条的值
        weakSelf.slider.value = currentTime/totalTime;
        
        if (_buttonPlay.selected == YES && _totalBuffer > (NSInteger)currentTime) {
            [weakSelf.player play];
        }
        
        //设置time label上的text
        weakSelf.labelTime.text = [NSString stringWithFormat:@"%.2d:%.2d/%@", (int)(currentTime/60), ((int)currentTime%60), weakSelf.totalTime];
        
        
    }];
}
//imageUrl, title, favoriteID, pushWich
- (void)prepareData {

    NSString *url = [NSString stringWithFormat:HomeDetailURL, _postid];
    
    [HttpRequest requestHttpWithUrl:url AndReturnBlock:^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSDictionary *dic = data[@"data"];
            PlayerModel *model = [PlayerModel createModelWithDic:dic];
            NSArray *arr = model.content[@"video"];
            NSDictionary *dict = arr[0];
            _mp4Url = dict[@"qiniu_url"];
            NSArray *array = @[dict[@"image"], model.title, model.postid, model.rating, @"0"];
            [_favouriteArr addObjectsFromArray:array];
            [self customUI];
            
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];//加上黑线
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [_player pause];
    
}

- (void)dealloc {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

#pragma mark -懒加载，创建播放器对象
- (AVPlayer *)player {
    if (!_player) {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        
        //给AVPlayerItem添加播放完成通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    }
    return _player;
}

#pragma mark -懒加载，创建AVPlayerItem对象
- (AVPlayerItem *)playerItem {
    if(!_playerItem) {
        if (_mp4Url != nil) {
            NSURL*url=[NSURL URLWithString:_mp4Url];
            self.playerItem= [AVPlayerItem playerItemWithURL:url];
            
            //观察playerItem的状态变化
            [self.playerItem addObserver:self forKeyPath:@"status"options:NSKeyValueObservingOptionNew context:nil];
            
            //加载缓存
            [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges"options:NSKeyValueObservingOptionNew context:nil];
        } 
        
    }
    return _playerItem;
}


//播放完成通知
//- (void)playbackFinished:(NSNotification *)noti {
//    
//}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    if([keyPath isEqualToString:@"status"]) {
        
        switch (self.player.status) {
                
                /*
                 AVPlayerStatusUnknown,
                 AVPlayerStatusReadyToPlay,
                 AVPlayerStatusFailed
                 */
            case AVPlayerStatusUnknown:
                NSLog(@"未知状态");
                break;
                
            case AVPlayerStatusReadyToPlay:
                NSLog(@"准备就绪，可以使用");
                NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(_playerItem.duration));
                
                [self setUpPlayer];
                [self.slider setThumbImage:[UIImage imageNamed:@"Expression_5@2x.png"]forState:UIControlStateNormal];
                self.slider.enabled = YES;
                
                
                [_mp4Active stopAnimating]; // 结束旋转
                [_mp4Active setHidesWhenStopped:YES]; //当旋转结束时隐藏
                
                //设置按钮状态为播放
                _buttonPlay.selected = YES;
                [_player play];
                //才可进行播放
                break;
            case AVPlayerStatusFailed:
                NSLog(@"发生错误，无法使用");
                break;
                
            default:
                break;
        }
        
        //计算视频总时间
        CMTime totalTime = _playerItem.duration;
        
        self.totalMovieDuration= (CGFloat)totalTime.value/ totalTime.timescale;
        
        //转化时间的格式
        NSDate*d = [NSDate dateWithTimeIntervalSince1970:self.totalMovieDuration];
        NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
        if(self.totalMovieDuration/3600>=1) {
            [formatter setDateFormat:@"HH:mm:ss"];
        }else{
            [formatter setDateFormat:@"mm:ss"];
        }
        NSString*showtimeNew = [formatter stringFromDate:d];
        
        //给labelTime赋值
        _totalTime = showtimeNew;
        
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array = _playerItem.loadedTimeRanges;
        
        NSLog(@"array = %@", array);
        
        //本次缓冲时间范围
        
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        
        float startSeconds =CMTimeGetSeconds(timeRange.start);
        
        float durationSeconds =CMTimeGetSeconds(timeRange.duration);
        
        //缓冲总长度
        
        _totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",_totalBuffer);
        
        //更新进度条
        [_progressLine setProgress:_totalBuffer *1.0/self.totalMovieDuration];
        
    }

    
}

- (void)customUI {
   
    
    
    _playView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, WIDTH/16*9)];
    _playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playView];
    
    _width = _playView.frame.size.width;
    _height = _playView.frame.size.height;
    
    //视频播放层
    _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.frame=CGRectMake(0, 0, WIDTH, WIDTH/16*9);
    _playerLayer.videoGravity=AVLayerVideoGravityResize;
    [_playView.layer addSublayer:_playerLayer];
    
    //全透
    _controlView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
    [_playView addSubview:_controlView];
    
    _controlView.userInteractionEnabled = YES;//开启交互
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_controlView addGestureRecognizer:tap];
    _isalpha = NO;
    
    //半透透明层，上面加控件
    _progressView = [[UIView alloc]initWithFrame:CGRectMake(0, _width/16*9-40, _width, 40)];
    _progressView.backgroundColor = [UIColor blackColor];
    [_controlView addSubview:_progressView];
    
    //播放暂停按钮事件
    self.buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonPlay.frame=CGRectMake(0, 0, 30, 30);
    self.buttonPlay.center = _controlView.center;
    [self.buttonPlay setBackgroundImage:[UIImage imageNamed:@"play32.png"]forState:UIControlStateNormal];//暂停
    [self.buttonPlay setBackgroundImage:[UIImage imageNamed:@"stop32.png"]forState:UIControlStateSelected];//播放
    
    self.buttonPlay.layer.masksToBounds=YES;
    self.buttonPlay.layer.cornerRadius=20;
    [_controlView addSubview:self.buttonPlay];
    
    [self.buttonPlay addTarget:self action:@selector(handlePlay:)forControlEvents:UIControlEventTouchUpInside];
    
    //缩放全屏按钮
    _buttonScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonScreen.frame = CGRectMake(_width-30, 7, 26, 26);
    [_buttonScreen setImage:[UIImage imageNamed:@"screen32.png"] forState:UIControlStateNormal];
    [_buttonScreen addTarget:self action:@selector(screenClick:) forControlEvents:UIControlEventTouchUpInside];
    [_progressView addSubview:_buttonScreen];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_buttonScreen];
//    self.navigationItem.rightBarButtonItem = item;
    
    //进度条
    _progressLine = [[UIProgressView alloc]initWithFrame:CGRectMake(85, 20, _width-130, 20)];
    _progressLine.progress = 0;
    [_progressView addSubview:_progressLine];
    
    // slider滑条事件
    self.slider= [[UISlider alloc]initWithFrame:CGRectMake(80,11,_width-120,20)];
    self.slider.maximumTrackTintColor= [UIColor clearColor];
    self.slider.minimumValue=0;
    self.slider.maximumValue=1;
    self.slider.enabled = NO;
    [self.slider setThumbImage:[UIImage imageNamed:@"Expression_5@2x"] forState:UIControlStateNormal];
    [_progressView addSubview:self.slider];

    //按下去的时候触发
    [_slider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    //弹起时触发
    [_slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    //时间Label
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    _labelTime.text = @"00:00/00:00";
    _labelTime.textColor = [UIColor whiteColor];
    _labelTime.font = [UIFont systemFontOfSize:11];
    [_progressView addSubview:_labelTime];
    
    _mp4Active = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _mp4Active.center = CGPointMake(_width/2, _height/2);
    _mp4Active.color = [UIColor blueColor]; // 改变圈圈的颜色为红色； iOS5引入
    [_mp4Active startAnimating]; // 开始旋转
    
    [_controlView addSubview:_mp4Active];
    
}

- (void)webData {
    
    _webActive = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _webActive.center = CGPointMake(WIDTH/2, ( HEIGHT-WIDTH/16*9-20)/2);
    _webActive.color = [UIColor blueColor]; // 改变圈圈的颜色为红色； iOS5引入
    
    
    //网页视图
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, WIDTH/16*9+20, WIDTH, HEIGHT-WIDTH/16*9-20)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView addSubview:_webActive];
    [_webActive startAnimating]; // 开始旋转
    
    _strUrl = [NSString stringWithFormat:LastWebUrl, _postid];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_strUrl]];
    [_webView loadRequest:request];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_webActive stopAnimating]; // 结束旋转
    [_webActive setHidesWhenStopped:YES]; //当旋转结束时隐藏
}


#pragma mark -- slider事件
//当手指弹起的时候触发
-(void)touchUp:(UISlider *)slider{
//    [self.player play];
    //播放
}
//当值发生变化一直触发
-(void)valueChange:(UISlider *)slider{
    [self.player pause];
//    NSLog(@"-=-=-=-=-=-=-=-=%f", slider.value);
    /*
     CMTimeScale timeScale;//每秒播放的帧数
     CMTimeValue value;//帧数
     _player.currentItem.duration.value;//总帧数
     _player.currentItem.duration.timescale;//每秒播放的帧数
     */
    //根据slider值 找到对应的帧数 获取帧数对应的播放时间
    CMTime currentTime = CMTimeMake(_player.currentItem.duration.value * slider.value, _player.currentItem.duration.timescale);
    //跳转到curentTime的位置播放
    [self.player seekToTime:currentTime];
    [self.player play];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    if (_isalpha == NO) {
        _buttonPlay.alpha= 0;
        _progressView.alpha = 0;
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _isalpha = YES;
    } else if (_isalpha == YES) {
        _buttonPlay.alpha= 1;
        _progressView.alpha = 1;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _isalpha = NO;
    }
}

//播放暂停按钮事件
- (void)handlePlay:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        [_player play];
    } else {
        sender.selected = NO;
        [_player pause];
    }
}
//缩放全屏按钮事件
- (void)screenClick:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIApplication sharedApplication].statusBarHidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            _playView.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
            _playView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            _controlView.frame = CGRectMake(0, 0, HEIGHT, WIDTH);
            _playerLayer.frame = CGRectMake(0, 0,  HEIGHT, WIDTH);
            
            _progressView.frame = CGRectMake(0, WIDTH-40, HEIGHT, 40);
            self.buttonPlay.center = _controlView.center;
            _buttonScreen.frame = CGRectMake(HEIGHT-40, 7, 30, 30);
            _progressLine.frame = CGRectMake(90, 20, HEIGHT-140, 20);
            _slider.frame = CGRectMake(85,11,HEIGHT-130,20);
        }];
        
    } else {
        sender.selected = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            _playView.transform = CGAffineTransformMakeRotation((0.0f * M_PI) / 180.0f);
            _playView.frame = CGRectMake(0, 20, _width, _height);
            _controlView.frame = CGRectMake(0, 0, _width, _height);
            _playerLayer.frame = CGRectMake(0, 0, _width, _height);
            
            _progressView.frame = CGRectMake(0, _width/16*9-40, _width, 40);
            self.buttonPlay.center = _controlView.center;
            _buttonScreen.frame = CGRectMake(_width-30, 7, 26, 26);
            _progressLine.frame = CGRectMake(85, 20, _width-130, 20);
            _slider.frame = CGRectMake(80,11,_width-120,20);
        }];
    }
}
























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
