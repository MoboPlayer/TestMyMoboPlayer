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
    NSArray *_localMovies;
    NSArray *_remoteMovies;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.tableView];
}

//- (BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)launchDebugTest
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:4
                                                                              inSection:1]];
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
    [self reloadMovies];
    [self.tableView reloadData];
}

- (void) reloadMovies
{
    NSMutableArray *ma = [NSMutableArray array];
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *folder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES) lastObject];
    NSArray *contents = [fm contentsOfDirectoryAtPath:folder error:nil];
    
    for (NSString *filename in contents) {
        
        if (filename.length > 0 &&
            [filename characterAtIndex:0] != '.') {
            
            NSString *path = [folder stringByAppendingPathComponent:filename];
            NSDictionary *attr = [fm attributesOfItemAtPath:path error:nil];
            if (attr) {
                id fileType = [attr valueForKey:NSFileType];
                if ([fileType isEqual: NSFileTypeRegular] ||
                    [fileType isEqual: NSFileTypeSymbolicLink]) {
                    
                    NSString *ext = path.pathExtension.lowercaseString;
                    
                    if ([ext isEqualToString:@"mp3"] ||
                        [ext isEqualToString:@"caff"]||
                        [ext isEqualToString:@"aiff"]||
                        [ext isEqualToString:@"ogg"] ||
                        [ext isEqualToString:@"wma"] ||
                        [ext isEqualToString:@"m4a"] ||
                        [ext isEqualToString:@"m4v"] ||
                        [ext isEqualToString:@"wmv"] ||
                        [ext isEqualToString:@"3gp"] ||
                        [ext isEqualToString:@"mp4"] ||
                        [ext isEqualToString:@"mov"] ||
                        [ext isEqualToString:@"avi"] ||
                        [ext isEqualToString:@"mkv"] ||
                        [ext isEqualToString:@"mpeg"]||
                        [ext isEqualToString:@"mpg"] ||
                        [ext isEqualToString:@"flv"] ||
                        [ext isEqualToString:@"vob"]) {
                        
                        [ma addObject:path];
                    }
                }
            }
        }
    }
    
    // Add all the movies present in the app bundle.
    //添加本地视频
    NSBundle *bundle = [NSBundle mainBundle];
    
    /*
    [ma addObject:[bundle pathForResource:@"Adele" ofType:@"mp4"]];
    [ma addObject:[bundle pathForResource:@"Miniature" ofType:@"mp4"]];
    [ma addObject:[bundle pathForResource:@"2.simple" ofType:@"mp4"]];
    [ma addObject:[bundle pathForResource:@"VE" ofType:@"flv"]];
    [ma addObject:[bundle pathForResource:@"test" ofType:@"flv"]];
    [ma addObject:@"/var/1234.flv"];
    */
//    [ma addObject:[bundle pathForResource:@"1111" ofType:@"mp4"]];
//    [ma addObject:[bundle pathForResource:@"2222" ofType:@"mp4"]];
    
    [ma sortedArrayUsingSelector:@selector(compare:)];
    
    _localMovies = [ma copy];
    
    self.title = @"MoboPlayer";
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag: 0];
    
    _remoteMovies = @[
                      @"rtmp://61.133.116.49/flv/mp4:n2014/jxjy/kc213/kj2276/fc/gdxxkjzd201401.mp4",
                      @"http://192.72.1.1/SD/Normal/F/FILE110119-001359F.MOV",
                      @"http://192.72.1.1/SD/Normal/F/FILE110119-001322F.MOV",
                      ];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:     return @"Remote";
        case 1:     return @"Local";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:     return _remoteMovies.count;
        case 1:     return _localMovies.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *path;
    
    if (indexPath.section == 0) {
        
        path = _remoteMovies[indexPath.row];
        
    } else {
        
        path = _localMovies[indexPath.row];
    }
    NSString *subPath = path.lastPathComponent;
    
    cell.textLabel.text = subPath;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *path;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row >= _remoteMovies.count) return;
        path = _remoteMovies[indexPath.row];
        
    } else {
        
        if (indexPath.row >= _localMovies.count) return;
        path = _localMovies[indexPath.row];
    }
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[MoboParameterDisableDeinterlacing] = @(YES);
    
    // enable buffering
    parameters[MoboParameterMinBufferedDuration] = @(0.5f);
    parameters[MoboParameterMaxBufferedDuration] = @(1.0f);
    parameters[MoboParameterRTMPLive] = @(YES);
    parameters[MoboParameterOpenAudioOnly] = @(NO);
    
    MyVideoViewController *vc = [[MyVideoViewController alloc] initWithNibName:nil bundle:nil];
    [vc softMovieViewControllerWithContentPath:path parameters:parameters];
//    [vc softMovieViewControllerWithContentPath:path parameters:parameters frame:CGRectMake(0, 0, 300, 300)];
    //[vc movieViewControllerWithContentPath:path parameters:parameters];
    vc.moboPlayer.moboControlStyle = MoboPlayerControlStyleNone;
    vc.moboPlayer.moboScalingMode = MoboPlayerScalingModeFill;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(genThumbnail:) userInfo:path repeats:NO];
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(openSubtitle) userInfo:nil repeats:NO];
    [self presentViewController:vc animated:YES completion:nil];
}



- (void)openSubtitle
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Godzilla.2014.BluRay.720p.DTS.x264-CHD.chs" ofType:@"srt"];
    int ret = [MoboViewController openSubtitle:path];
    if (ret >= 0)
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getSubtitle) userInfo:nil repeats:YES];
}

- (void)getSubtitle
{
    static int i = 0;
    int s = i*1000;
    i++;
    NSString *subtitle = [MoboViewController getSubtitleOnTime:s];
    if (subtitle) {
        NSLog(@"subtitle:%@", subtitle);
    }
}
- (void)genThumbnail:(NSTimer *)timer
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    
    [MoboViewController generateThumbnail:(NSString *)[timer userInfo] atPath:filePath atTime:5 withWidth:0 height:0];
}

@end
