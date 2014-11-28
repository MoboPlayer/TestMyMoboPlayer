//
//  APKUtilities.m
//  MoboPlayerDemo
//
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 MoboTeam. All rights reserved.
//

#import "APKUtilities.h"

@implementation APKUtilities

+(NSString *)timeToHumanString:(unsigned long)ms
{
    unsigned long seconds, h, m, s;
    char buff[128] = { 0 };
    NSString *nsRet = nil;
    
    seconds = ms / 1000;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    snprintf(buff, sizeof(buff), "%02ld:%02ld:%02ld", h, m, s);
    nsRet = [[NSString alloc] initWithCString:buff
                                      encoding:NSUTF8StringEncoding] ;
    
    return nsRet;
}
@end
