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
extern NSString * const MoboParameterOpenAudioOnly;          // BOOL


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

/**
 *  @description
 *      generate a thumbnail for the file, and save the png at pngSavePath, at time (second)
 *  @param
 *      file media file path
 *      pngSavePath png save path
 *      time generate time in second
 *  @return
 *      a int value for error code 
 *      == 0 is success
 *      <  0 is failed 
 */
+ (int) generateThumbnail:(NSString *)file atPath:(NSString *)pngSavePath atTime:(int)time;


/**
 *  @description
 *      open subtitle file and then if success you can get subtitle string by
 *      getExSubtitle method
 *  @param
 *      file subtitle file path
 *  @return
 *      a int value for error code 
 *      >= 0 is success
 *      <  0 is failed 
 */
+ (int)openSubtitle:(NSString *)file;

/**
 *  @description
 *      return a subtitle string at currentTime
 *  @param
 *      currentTime the subtitle time you want at time in second
 *  @return
 *      a string for subtitle
 */

+ (NSString *)getExSubtitleOnTime:(int)currentTime;

@end
