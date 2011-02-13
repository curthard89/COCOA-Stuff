//
//  ZoomWindow.h
//  Caffeinated
//
//  Created by Curtis on 13/02/2011.
//  Copyright 2011 GeekyGoodness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface ZoomWindow : NSWindow {
    
    float animationDuration;
    float animationStartScale;
    
@private
    BOOL renderOfScreen;
    BOOL isAnimating;
    NSWindow * overScreenWindow;
    
}

@property ( nonatomic, assign ) BOOL renderOfScreen;
@property ( nonatomic, assign ) BOOL isAnimating;
@property ( nonatomic, assign ) float animationDuration;
@property ( nonatomic, assign ) float animationStartScale;

- (void)zoomIn:(id)sender;

@end
