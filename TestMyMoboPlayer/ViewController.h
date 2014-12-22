//
//  ViewController.h
//  TestMyMoboPlayer
//
//  Created by Mac on 14-11-6.
//  Copyright (c) 2014年 Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyVideoViewController.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *movieView;


@property (strong, nonatomic) MyVideoViewController *myVideoViewController;

@end
