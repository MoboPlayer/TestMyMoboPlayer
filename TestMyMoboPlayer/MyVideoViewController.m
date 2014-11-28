//
//  MyVideoViewController.m
//  TestMyMoboPlayer
//
//  Created by Mac on 14-11-6.
//  Copyright (c) 2014年 Shenzhen. All rights reserved.
//

#import "MyVideoViewController.h"
#import "APKUtilities.h"

@interface MyVideoViewController ()

@end

@implementation MyVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackground:) name:@"applicationDidEnterBackgroundNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterForeground:) name:@"applicationWillEnterForegroundNotification" object:nil];
    
    [self.progressSlider setContinuous:YES];

    //不锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    //单指单击播放界面
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControlsVisible)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    //单指单击播放界面也可以使用下面代码：
//    UITapGestureRecognizer *tapOnVideoRecognizer = [[UITapGestureRecognizer alloc]
//                                                    initWithTarget:self action:@selector(toggleControlsVisible)];
//    tapOnVideoRecognizer.delegate = self;
//    [self.view addGestureRecognizer:tapOnVideoRecognizer];
    
    //单指双击播放界面
    UITapGestureRecognizer *doubleTapsGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeScalingMode)];
    doubleTapsGesture.numberOfTouchesRequired = 1;
    doubleTapsGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapsGesture];
    
    //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
    [singleTapGesture requireGestureRecognizerToFail:doubleTapsGesture];
    
    
    //点击Slider（由于Slider系统里面都是拖动操作，没有点击操作，所以点击Slider功能去掉了）
//    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressSliderTapped:)] ;
//    [self.progressSlider addGestureRecognizer:gr];
    
    //点击topPanel
    UITapGestureRecognizer *gr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_resetIdleTimer)];
    [self.topPanel addGestureRecognizer:gr2];
    
    //点击bottomPanel
    UITapGestureRecognizer *gr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_resetIdleTimer)];
    [self.bottomPanel addGestureRecognizer:gr3];
    
    //通知
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(moboViewPlaybackDidFinish:) name:MoboPlayerPlaybackDidFinishNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(moboViewPlaybackFailed:) name:MoboPlayerPlaybackFailedNotification object:nil];
    
    //设置显示时间和显示progressSlider
    self.syncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:
                          (1.0/3)
//                          (1.0)
                                                      target:self
                                                    selector:@selector(syncUIStatus)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //页面将要进入前台，开启定时器
    [self.syncSeekTimer setFireDate:[NSDate distantPast]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //页面消失，进入后台不显示该页面，关闭定时器
    [self.syncSeekTimer setFireDate:[NSDate distantFuture]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification
{
    if ([self.moboPlayer isPlaying]) {
		[self.moboPlayer pause];
    }
    
    UIImage *playIcon = [UIImage imageNamed:@"PlayIcon"];
    [self.playOrPauseButton setImage:playIcon forState:UIControlStateNormal];
}

- (void)handleApplicationDidEnterForeground:(NSNotification *)notification
{
    self.topPanel.hidden = NO;
    self.bottomPanel.hidden = NO;
    
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
    
    if ([self.moboPlayer isPlaying]) {
        [self.moboPlayer pause];
        
        UIImage *pauseIcon = [UIImage imageNamed:@"PlayIcon"];
        [self.playOrPauseButton setImage:pauseIcon forState:UIControlStateNormal];
  	}
}

#pragma mark - moboPlayerNotification

-(void)moboViewPlaybackDidFinish:(NSNotification *)notification
{
    NSLog(@"✅MoboPlayer播放完成！");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)moboViewPlaybackFailed:(NSNotification *)notification
{
    NSLog(@"❌MoboPlayer播放失败！");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI Operation

-(void)syncUIStatus
{
    if (!self.durationTime) {
        self.durationTime = [self.moboPlayer getFullTime];
//        NSLog(@"📗self.durationTime is %ld",self.durationTime);
    }
    
	if (!self.isProgressDragging) {
		self.currentPositionTime  = [self.moboPlayer getCurrentTime];
//        NSLog(@"📓self.currentPositionTime is %ld", self.currentPositionTime);
		[self.progressSlider setValue:(float)self.currentPositionTime / self.durationTime];
        
		self.currentPostionLabel.text = [APKUtilities timeToHumanString:(self.currentPositionTime * 1000)];
        self.durationLabel.text = [APKUtilities timeToHumanString:(self.durationTime * 1000)];
	}
}

- (void)runTimer
{
    if ([self.moboPlayer hasSubtitle]) {
        NSLog(@"has subtitle");
        NSLog(@"subtitle: %@", [self.moboPlayer getSubtitleString]);
    }
}

-(void)changeScalingMode
{
    NSLog(@"📘双击播放界面");
}

- (void)toggleControlsVisible
{
    BOOL bControlsHidden = !self.topPanel.hidden;
    
    if (bControlsHidden == YES) {
        [self hiddenAnimation];
    }
    else{
        self.topPanel.hidden = bControlsHidden;
        self.bottomPanel.hidden = bControlsHidden;
    }
    
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
}

- (void)_resetIdleTimer    //设置时间间隔，控件的显示与隐藏
{
    if (!self.idleTimer)
        self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                      target:self
                                                    selector:@selector(idleTimerExceeded)
                                                    userInfo:nil
                                                     repeats:NO];
    else {
        if (fabs([self.idleTimer.fireDate timeIntervalSinceNow]) < 5.)
            
            //setFireDate: 重新设置定时器开始运行的时间
            [self.idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];    //重新设置定时器开始运行的时间
    }
}

- (void)idleTimerExceeded
{
    _idleTimer = nil;
    
    if (!self.topPanel.hidden)
        [self toggleControlsVisible];
}

-(void)hiddenAnimation
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.duration = 0.1;
    
    [self.topPanel.layer addAnimation:animation forKey:nil];
    self.topPanel.hidden = YES;
    
    [self.bottomPanel.layer addAnimation:animation forKey:nil];
    self.bottomPanel.hidden = YES;
}

//-(void)progressSliderTapped:(UIGestureRecognizer *)g
//{
//    //设置时间间隔，控件的显示与隐藏
//    [self _resetIdleTimer];
//    
//    self.isProgressDragging = YES;
//    
//    UISlider* s = (UISlider*)g.view;
//    if (s.highlighted)
//        return;
//    CGPoint pt = [g locationInView:s];
//    CGFloat percentage = pt.x / s.bounds.size.width;
//    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
//    CGFloat value = s.minimumValue + delta;
//    [s setValue:value animated:YES];
//    float seek = percentage * self.durationTime;
//	
//    NSString *timeString = [APKUtilities timeToHumanString:(seek * 1000)];
//    self.currentPostionLabel.text = timeString;
//	NSLog(@"📗点击Slider到时间：%@", timeString);
//    
//    [self.moboPlayer seekToTime:seek];
//    
//    self.isProgressDragging = NO;
//}

- (void)_setPositionForReal
{
    float seek = _progressSlider.value * self.durationTime;
    [self.moboPlayer seekToTime:seek];
    
    NSString *timeString = [APKUtilities timeToHumanString:(seek * 1000)];
    self.currentPostionLabel.text = timeString;
    NSLog(@"📗拖动Slider到时间：%@", timeString);
    
    self.isProgressDragging = NO;
}

#pragma mark - Button and  Slider Operation

- (IBAction)progressSliderDownActioon:(id)sender {
    self.isProgressDragging = YES;
}

- (IBAction)progressSliderUpAction:(id)sender {
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
    
    //    /* we need to limit the number of events sent by the slider, since otherwise, the user
    //     * wouldn't see the I-frames when seeking on current mobile devices. This isn't a problem
    //     * within the Simulator, but especially on older ARMv7 devices, it's clearly noticeable. */

//    [self performSelector:@selector(_setPositionForReal) withObject:nil afterDelay:0];
    [self _setPositionForReal];
}

- (IBAction)dragProgressSliderAction:(id)sender {
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
    
    float seek = _progressSlider.value * self.durationTime;
    self.currentPostionLabel.text = [APKUtilities timeToHumanString:(long)(seek *1000)];
}

- (IBAction)done:(id)sender {
    
    [self quicklyStopMovie];

    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playOrPause:(id)sender {
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
    
    if ([self.moboPlayer isPlaying])
    {
        //关闭定时器
        [self.syncSeekTimer setFireDate:[NSDate distantFuture]];
        
        [self.moboPlayer pause];
        UIImage *playIcon = [UIImage imageNamed:@"PlayIcon"];
        [self.playOrPauseButton setImage:playIcon forState:UIControlStateNormal];
    }
    else{
        //开启定时器
        [self.syncSeekTimer setFireDate:[NSDate distantPast]];
        
        [self.moboPlayer play];
        UIImage *pauseIcon = [UIImage imageNamed:@"PauseIcon"];
        [self.playOrPauseButton setImage:pauseIcon forState:UIControlStateNormal];
    }
    NSLog(@"📘**********************");
    NSLog(@"📘getFullTime %f",[self.moboPlayer getFullTime]);
    NSLog(@"📘getCurrentTime %f",[self.moboPlayer getCurrentTime]);
    NSLog(@"📘isBufferring %@",[self.moboPlayer isBufferring] ? @"YES" : @"NO");
    NSLog(@"📘getBufferPercent %f",[self.moboPlayer getBufferPercent]);
    NSLog(@"📘hasSubTitle %@",[self.moboPlayer hasSubtitle] ? @"YES" : @"NO");
    NSLog(@"📘hasAudio %@",[self.moboPlayer hasAudio] ? @"YES" : @"NO");
    NSLog(@"📘Audio count is %ld",[self.moboPlayer getAudioCount]);
}

- (IBAction)forwardPlay:(id)sender {
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
    
    [self.moboPlayer seekToTime: [self.moboPlayer getCurrentTime] + 10];
}

- (IBAction)backPlay:(id)sender {
    //设置时间间隔，控件的显示与隐藏
    [self _resetIdleTimer];
    
    [self.moboPlayer seekToTime: [self.moboPlayer getCurrentTime] - 10];
}

#pragma mark - Others
-(void)quicklyStopMovie
{
	[self.moboPlayer stop];
    
    //停止timer的运行，是永久的停止：（注意：停止后，一定要将timer赋空，否则还是没有释放。)
	[self.syncSeekTimer invalidate];
	self.syncSeekTimer = nil;
    
	self.progressSlider.value = 0.0;
    
	self.currentPostionLabel.text = @"00:00:00";
	self.durationLabel.text = @"00:00:00";

	self.currentPositionTime = 0;
	self.durationTime = 0;

    //恢复锁屏状态
	[UIApplication sharedApplication].idleTimerDisabled = NO;
    [self removeAllObserver];
}

- (void)removeAllObserver
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:MoboPlayerPlaybackDidFinishNotification object:nil];
    [notificationCenter removeObserver:self name:MoboPlayerPlaybackFailedNotification object:nil];
    
}

@end
