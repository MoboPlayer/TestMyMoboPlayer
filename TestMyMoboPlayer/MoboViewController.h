//
//  MoboViewController.h
//  MoboPlayer_iOS
//
//  Created by 孙军 on 14-10-10.
//  Copyright (c) 2014年 MoboTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoboPlayerProtocol.h"
#import "MoboPlayerNotification.h"

#define HARD_DECODE 1
#define SOFT_DECODE 2

extern NSString * const MoboParameterMinBufferedDuration;    // Float
extern NSString * const MoboParameterMaxBufferedDuration;    // Float
extern NSString * const MoboParameterDisableDeinterlacing;   // BOOL
extern NSString * const MoboParameterRTMPLive;               // BOOL


@interface MoboViewController : UIViewController

@property (nonatomic, retain) NSString *filePath;
@property int decodeMode;

@property (nonatomic, retain) id<MoboPlayerProtocol> moboPlayer;

/**
 *  @description
 *      init the movie player with path and parameters
 *      it will first call system player if failed then auto call non-system player
 *  @param
 *      path the media file path include local file or network file
 *      parameters set the MoboParameterMinBufferedDuration other parameters, see the examples
 *  @return
 *      a MoboViewController instance
 */

- (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters;

/**
 *  @description
 *      init the movie player with path and parameters
 *      it will call non-system player
 *  @param
 *      path the media file path include local file or network file
 *      parameters set the MoboParameterMinBufferedDuration other parameters, see the examples
 *  @return
 *      a MoboViewController instance
 */

- (id) softMovieViewControllerWithContentPath: (NSString *) path
                                   parameters: (NSDictionary *) parameters;

@end
