//
//  LocalEventManager.h
//  Caffeinated
//
//  Created by Curtis Hard on 13/06/2011.
//  Copyright 2011 GeekyGoodness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalEvent.h"

@interface LocalEventManager : NSObject {
    NSMutableDictionary * masks;
    NSMutableDictionary * events;
}

+ (LocalEventManager *)defaultController;

+ (LocalEventUID *)observeMask:(NSEventMask)mask
                        window:(NSWindow *)window
                      priority:(LocalEventPriority)priority
                         block:(NSEvent * (^)(NSEvent * event))block;

+ (void)removeObserver:(LocalEventUID *)UID;

- (LocalEventUID *)observeMask:(NSEventMask)mask
                        window:(NSWindow *)window
                      priority:(LocalEventPriority)priority
                         block:(NSEvent * (^)(NSEvent * event))block;

- (void)removeObserver:(LocalEventUID *)UID;

@end