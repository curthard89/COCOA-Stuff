//
//  LocalEvent.h
//  Caffeinated
//
//  Created by Curtis Hard on 13/06/2011.
//  Copyright 2011 GeekyGoodness. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    LocalEventPriorityVeryVeryHigh,
    LocalEventPriorityVeryHigh,
    LocalEventPriorityHigh,
    LocalEventPriorityNormal,
    LocalEventPriorityLow,
    LocalEventPriorityVeryLow
}

typedef LocalEventPriority;

typedef NSString LocalEventUID;
typedef NSEvent * (^LocalEventBlock)();

@interface LocalEvent : NSObject {
    
    int mask;
    int priority;
    LocalEventUID * UID;
    LocalEventBlock block;
    NSWindow * window;
    
}

@property ( nonatomic, assign ) int mask;
@property ( nonatomic, assign ) int priority;
@property ( nonatomic, copy ) LocalEventBlock block;
@property ( nonatomic, copy ) LocalEventUID * UID;
@property ( nonatomic, retain ) NSWindow * window;

@end
