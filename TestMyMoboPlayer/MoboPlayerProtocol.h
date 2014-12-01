//
//  MoboPlayerProtocol.h
//  MoboPlayer_iOS
//
//  Created by 孙军 on 14-10-10.
//  Copyright (c) 2014年 MoboTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    MoboPlayerScalingModeNone,       // No scaling
    MoboPlayerScalingModeAspectFit,  // Uniform scale until one dimension fits
    MoboPlayerScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    MoboPlayerScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};
typedef NSInteger MoboPlayerScalingMode;

enum {
    MoboPlayerPlaybackStateStopped,
    MoboPlayerPlaybackStatePlaying,
    MoboPlayerPlaybackStatePaused,
    MoboPlayerPlaybackStateInterrupted,
    MoboPlayerPlaybackStateSeekingForward,
    MoboPlayerPlaybackStateSeekingBackward
};
typedef NSInteger MoboPlayerPlaybackState;

enum {
    MoboPlayerLoadStateUnknown        = 0,
    MoboPlayerLoadStatePlayable       = 1 << 0,
    MoboPlayerLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    MoboPlayerLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
};
typedef NSInteger MoboPlayerLoadState;

enum {
    MoboPlayerRepeatModeNone,
    MoboPlayerRepeatModeOne
};
typedef NSInteger MoboPlayerRepeatMode;

enum {
    MoboPlayerControlStyleNone,       // No controls
    MoboPlayerControlStyleEmbedded,   // Controls for an embedded view
    MoboPlayerControlStyleFullscreen, // Controls for fullscreen playback
    
    MoboPlayerControlStyleDefault = MoboPlayerControlStyleEmbedded
};
typedef NSInteger MoboPlayerControlStyle;

enum {
    MoboPlayerFinishReasonPlaybackEnded,
    MoboPlayerFinishReasonPlaybackError,
    MoboPlayerFinishReasonUserExited
};
typedef NSInteger MoboPlayerFinishReason;

// -----------------------------------------------------------------------------
// Movie Property Types

enum {
    MoboPlayerMediaTypeMaskNone  = 0,
    MoboPlayerMediaTypeMaskVideo = 1 << 0,
    MoboPlayerMediaTypeMaskAudio = 1 << 1
};
typedef NSInteger MoboPlayerMediaTypeMask;

enum {
    MoboPlayerSourceTypeUnknown,
    MoboPlayerSourceTypeFile,     // Local or progressively downloaded network content
    MoboPlayerSourceTypeStreaming // Live or on-demand streaming content
};
typedef NSInteger MoboPlayerSourceType;

@protocol MoboPlayerProtocol <NSObject>

@property (nonatomic) MoboPlayerControlStyle moboControlStyle;
@property (nonatomic, readonly) UIView *moboDisplayView;
@property (nonatomic) BOOL rtmpLive;
/**
 *  @description
 *      play the media file, called after movieViewControllerWithContentPath
 *  @param
 *      nil
 *  @return
 *      nil
 */

- (void) play;

/**
 *  @description
 *      pause the media file
 *  @param
 *      nil
 *  @return
 *      nil
 */

@optional
- (void) pause;

//All time unit is second

/**
 *  @description
 *      seek to the time, the unit is second
 *  @param
 *      position seek postion
 *  @return
 *      nil
 */

- (void) seekToTime: (CGFloat) position;

/**
 *  @description
 *      does the media file have subtitle
 *  @param
 *      nil
 *  @return
 *      if YES have subtitle or NO have not
 */

- (BOOL) hasSubtitle;

/**
 *  @description
 *      a media file may have multi-subtitles, get the subtitle count
 *  @param
 *      nil
 *  @return
 *      subtitle count
 */

- (NSUInteger) getSubtitleCount;

/**
 *  @description
 *      get current used subtitle stream number, start from 0
 *  @param
 *      nil
 *  @return
 *      selected subtitle stream
 */

- (NSInteger) selectedSubtitleStream;

/**
 *  @description
 *      set subtitle stream number, start from 0 to getSubtitleCount-1
 *      set -1 to close subtitle
 *  @param
 *      selected the selected subtitle stream number
 *  @return
 *      nil
 */

- (void) setSelectedSubtitleStream:(NSInteger)selected;

/**
 *  @description
 *      does the media file have audio
 *  @param
 *      nil
 *  @return
 *      if YES have audio or NO have not
 */

- (BOOL) hasAudio;

/**
 *  @description
 *      a media file may have multi-audio track, get the audio track count
 *  @param
 *      nil
 *  @return
 *      audio track count
 */

- (NSUInteger) getAudioCount;

/**
 *  @description
 *      get current used audio stream number, start from 0
 *  @param
 *      nil
 *  @return
 *      selected audio stream
 */

- (NSInteger) selectedAudioStream;

/**
 *  @description
 *      set audio stream number, start from 0 to getAudioCount-1
 *  @param
 *      selected the selected audio stream number
 *  @return
 *      nil
 */

- (void) setSelectedAudioStream:(NSInteger)selected;

/**
 *  @description
 *      get current playing status
 *  @param
 *      nil
 *  @return
 *      YES is playing now, NO is not playing now
 */

- (BOOL) isPlaying;

/**
 *  @description
 *      get the full duration of the meida file
 *  @param
 *      nil
 *  @return
 *      file duration and time unit is second
 */

- (CGFloat) getFullTime;

/**
 *  @description
 *      get the current playing time
 *  @param
 *      nil
 *  @return
 *      file current playing time and time unit is second
 */

- (CGFloat) getCurrentTime;

/**
 *  @description
 *      stop playing, dismiss the MoboViewController
 *  @param
 *      nil
 *  @return
 *      nil
 */

- (void) stop;

/**
 *  @description
 *      get current buffering status
 *  @param
 *      nil
 *  @return
 *      YES is bufferring now, NO is not bufferring
 */

- (BOOL) isBufferring;

/**
 *  buffer time set by use MoboParameterMinBufferedDuration
 *  Demo code:
 *
 *  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
 *  parameters[MoboParameterMinBufferedDuration] = @(5.0f);
 *  //and path is the file path
 *  MoboViewController *vc = [[MoboViewController alloc] movieViewControllerWithContentPath:path parameters:parameters]];
 *
 */

/**
 *  @description
 *      get current buffer percent, the value is currentBufferingDuration/MoboParameterMinBufferedDuration
 *  @param
 *      nil
 *  @return
 *      a float value from 0 to 1
 */
- (CGFloat) getBufferPercent;

/**
 *  @description
 *      get selected subtitle stream subtitle string
 *  @param
 *      nil
 *  @return
 *      a subtitle string
 */
- (NSString *) getSubtitleString;

@end
