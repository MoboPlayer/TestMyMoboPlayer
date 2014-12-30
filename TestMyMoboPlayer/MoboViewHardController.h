//
//  MoboViewHardController.h
//  MoboPlayer_iOS
//
//  Created by 孙军 on 14-10-10.
//  Copyright (c) 2014年 MoboTeam. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MoboPlayerProtocol.h"

@interface MoboViewHardController : MPMoviePlayerController <MoboPlayerProtocol>

+ (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters;

@property (nonatomic) MoboPlayerControlStyle moboControlStyle;
@property (nonatomic, readonly) UIView *moboDisplayView;

@end
