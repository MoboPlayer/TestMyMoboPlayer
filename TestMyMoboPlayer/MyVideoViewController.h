//
//  MyVideoViewController.h
//  TestMyMoboPlayer
//
//  Created by Mac on 14-11-6.
//  Copyright (c) 2014年 Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoboViewController.h"
#import "MoboPlayerErrorHandle.h"

@interface MyVideoViewController : MoboViewController<MoboPlayerErrorHandle>

@property (weak, nonatomic) IBOutlet UILabel *currentPostionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIView *topPanel;
@property (weak, nonatomic) IBOutlet UIView *bottomPanel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;

@property long durationTime;
@property long currentPositionTime;
@property (strong, nonatomic) NSTimer *syncSeekTimer;
@property BOOL isProgressDragging;
@property (strong, nonatomic) NSTimer *idleTimer;

- (IBAction)progressSliderDownActioon:(id)sender;
- (IBAction)progressSliderUpAction:(id)sender;
- (IBAction)dragProgressSliderAction:(id)sender;

- (IBAction)done:(id)sender;
- (IBAction)playOrPause:(id)sender;
- (IBAction)forwardPlay:(id)sender;
- (IBAction)backPlay:(id)sender;

@end
