//
//  MoboPlayerErrorHandle.h
//  MoboPlayer_iOS
//
//  Created by 孙军 on 14/12/30.
//  Copyright (c) 2014年 MoboTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoboPlayerErrorHandle <NSObject>

@optional
- (void)handleError: (NSInteger)errorCode;

@end
