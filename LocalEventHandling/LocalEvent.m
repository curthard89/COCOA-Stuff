//
//  LocalEvent.m
//  Caffeinated
//
//  Created by Curtis Hard on 13/06/2011.
//  Copyright 2011 GeekyGoodness. All rights reserved.
//

#import "LocalEvent.h"

@implementation LocalEvent

@synthesize priority, block, UID, mask, window;

- (void)dealloc
{
    [UID release], UID = nil;
    [block release], block = nil;
    [window release], window = nil;
    [super dealloc];
}

@end
