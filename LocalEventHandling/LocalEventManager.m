//
//  LocalEventManager.m
//  Caffeinated
//
//  Created by Curtis Hard on 13/06/2011.
//  Copyright 2011 GeekyGoodness. All rights reserved.
//

#import "LocalEventManager.h"

@implementation LocalEventManager

static LocalEventManager * defaultController = nil;

+ (LocalEventManager *)defaultController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultController = [[LocalEventManager alloc] init];
    });
    return defaultController;
}

- (void)dealloc
{
    [events release], events = nil;
    [masks release], masks = nil;
    [super dealloc];
}

- (id)init
{
    if( ( self = [super init] ) != nil )
    {
        masks = [[NSMutableDictionary alloc] init];
        events = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (LocalEventUID *)observeMask:(NSEventMask)mask
                        window:(NSWindow *)window
                      priority:(LocalEventPriority)priority
                         block:(NSEvent * (^)(NSEvent * event))block
{
    return [[[self class] defaultController] observeMask:mask
                                                  window:window
                                                priority:priority
                                                   block:block];
}

+ (void)removeObserver:(LocalEventUID *)UID
{
    [[[self class] defaultController] removeObserver:UID];
}

- (LocalEventUID *)observeMask:(NSEventMask)mask
                        window:(NSWindow *)window
                      priority:(LocalEventPriority)priority
                         block:(NSEvent * (^)(NSEvent * event))block
{
    NSString * maskString = [NSString stringWithFormat:@"%d",mask];
    if( ! [masks objectForKey:maskString] )
    {
        [masks setObject:[[[NSMutableArray alloc] init] autorelease]
                  forKey:maskString];
        [NSEvent addLocalMonitorForEventsMatchingMask:mask
                                              handler:^(NSEvent * event)
        {
            for( LocalEvent * localEvent in [masks objectForKey:maskString] )
            {
                if( [localEvent window] != nil && ( [event window] != [localEvent window] ) )
                {
                    continue;
                }
                if( [localEvent block]( event ) == nil )
                {
                    event = nil;
                    break;
                }
            }
            return event;
        }];
    }
    
    LocalEvent * event = [[[LocalEvent alloc] init] autorelease];
    [event setPriority:priority];
    [event setBlock:block];
    [event setMask:mask];
    [event setWindow:window];
    
    [(NSMutableArray *)[masks objectForKey:maskString] addObject:event];
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"priority"
                                                            ascending:YES];
    [(NSMutableArray *)[masks objectForKey:maskString] sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    NSString * UID = [[NSProcessInfo processInfo] globallyUniqueString];
    
    [events setObject:event
               forKey:UID];
    
    return (LocalEventUID *)UID;
}

- (void)removeObserver:(LocalEventUID *)UID
{
    LocalEvent * toRemove = [events objectForKey:UID];
    NSString * maskString = [NSString stringWithFormat:@"%d",[toRemove mask]];
    if( toRemove )
    {
        [(NSMutableArray *)[masks objectForKey:maskString] removeObject:toRemove];
        [events removeObjectForKey:UID];
    }
}

@end
