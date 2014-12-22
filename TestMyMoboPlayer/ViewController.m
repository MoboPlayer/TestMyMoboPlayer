//
//  ViewController.m
//  TestMyMoboPlayer
//
//  Created by Mac on 14-11-6.
//  Copyright (c) 2014年 Shenzhen. All rights reserved.
//

#import "ViewController.h"
#import "MoboViewController.h"
#import "MyVideoViewController.h"

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
    
    self.myVideoViewController = [[MyVideoViewController alloc] initWithNibName:@"MyVideoViewController" bundle:nil];
    
    [self.movieView addSubview:self.myVideoViewController.view];
    

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[MoboParameterDisableDeinterlacing] = @(YES);
    
    // enable buffering
    parameters[MoboParameterMinBufferedDuration] = @(0.5f);
    parameters[MoboParameterMaxBufferedDuration] = @(1.0f);
    parameters[MoboParameterRTMPLive] = @(NO);
    parameters[MoboParameterOpenAudioOnly] = @(NO);
    
    [self.myVideoViewController softMovieViewControllerWithContentPath:path parameters:parameters];
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
