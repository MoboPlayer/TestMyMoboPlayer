#import <UIKit/UIKit.h>
#import "MoboPlayerProtocol.h"
#import "MoboPlayerNotification.h"

@class MoboDecoder;

@interface MoboViewSoftController : NSObject<MoboPlayerProtocol, UITableViewDataSource, UITableViewDelegate>

+ (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters;
@property (nonatomic, retain)UIView *view;
@property (nonatomic) MoboPlayerControlStyle moboControlStyle;
@property (nonatomic, readonly) UIView *moboDisplayView;
@property (nonatomic) BOOL rtmpLive;
@property (readonly) BOOL playing;

@end
