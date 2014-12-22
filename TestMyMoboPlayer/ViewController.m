//
//  ViewController.m
//  TestMyMoboPlayer
//
//  Created by Mac on 14-11-6.
//  Copyright (c) 2014年 Shenzhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {

}

@end

@implementation ViewController

//- (BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path;
    NSBundle *bundle = [NSBundle mainBundle];
    path = [bundle pathForResource:@"Miniature" ofType:@"mp4"];
    
//    self.myVideoViewController = [[MyVideoViewController alloc] initWithNibName:@"MyVideoViewController" bundle:nil];
//    
//    [self.movieView addSubview:self.myVideoViewController.view];
    

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[MoboParameterDisableDeinterlacing] = @(YES);
    
    // enable buffering
    parameters[MoboParameterMinBufferedDuration] = @(0.5f);
    parameters[MoboParameterMaxBufferedDuration] = @(1.0f);
    parameters[MoboParameterRTMPLive] = @(NO);
    parameters[MoboParameterOpenAudioOnly] = @(NO);

    self.myVideoPlayer = [MoboViewSoftController movieViewControllerWithContentPath:path parameters:parameters];
    CGRect rect = CGRectMake(0, 100, 200, 200);
    self.myVideoPlayer.view.frame = rect;
    [self.movieView addSubview:self.myVideoPlayer.view];

//    [self.myVideoViewController softMovieViewControllerWithContentPath:path parameters:parameters];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
