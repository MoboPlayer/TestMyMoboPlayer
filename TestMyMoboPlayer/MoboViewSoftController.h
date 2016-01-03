#import <UIKit/UIKit.h>
#import "MoboPlayerProtocol.h"
#import "MoboPlayerNotification.h"

@class MoboDecoder;

@interface MoboViewSoftController : NSObject<MoboPlayerProtocol, UITableViewDataSource, UITableViewDelegate>

+ (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters;

+ (NSTimeInterval)outdateTimeStamp;
@property (nonatomic, retain) UIView *view;
@property (nonatomic) MoboPlayerControlStyle moboControlStyle;
@property (nonatomic) MoboPlayerScalingMode moboScalingMode;
@property (nonatomic) MoboPlayerPlaybackState moboPlaybackState;
@property (nonatomic, readonly) UIView *moboDisplayView;
@property (nonatomic) BOOL rtmpLive;
@property (nonatomic) BOOL downloadingPlaying;
@property (readonly) BOOL playing;

@property (nonatomic, retain) id<MoboPlayerErrorHandle> errorHandleDelegate;

@end
