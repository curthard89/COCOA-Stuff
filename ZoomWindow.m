//
//  ZoomWindow.m
//  Caffeinated
//
//  Created by Curtis Hard on 13/02/2011.
//  Copyright 2011 GeekyGoodness. All rights reserved.
//

#import "ZoomWindow.h"


@implementation ZoomWindow

@synthesize renderOfScreen, animationDuration, animationStartScale, isAnimating;

#define ORIGIN_OFF_SCREEN 16000

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    if( ( self = [super initWithContentRect:contentRect
                                  styleMask:aStyle
                                    backing:bufferingType
                                      defer:flag] ) != nil )
    {
        [self setAnimationDuration:.4];
        [self setAnimationStartScale:0.0];
        [self setIsAnimating:NO];
    }
    return self;
}

- (NSRect)constrainFrameRect:(NSRect)frameRect
                    toScreen:(NSScreen *)screen
{
    NSRect superRect = [super constrainFrameRect:frameRect
                                        toScreen:screen];
    if( [self renderOfScreen] )
    {
        superRect.origin.x -= ORIGIN_OFF_SCREEN;
    }
    return superRect;
}

- (void)zoomIn:(id)sender
{

    if( [self isAnimating] )
    {
        return;
    }
    
    if(
       ( [self isKeyWindow] || [self isVisible] ) ||
       [self isMiniaturized] ||
       ( ! [self isKeyWindow] && [self isVisible] ) ) {
        [self makeKeyAndOrderFront:self];
        return;
    }
    
    [self setIsAnimating:YES];
    [self setRenderOfScreen:NO];
    
    NSRect zoomToRect = [self constrainFrameRect:[self frame]
                                        toScreen:[NSScreen mainScreen]];
    
    NSScreen * screen = [NSScreen mainScreen];
    NSRect theRect = [screen frame];
    theRect.size.height -= [[NSStatusBar systemStatusBar] thickness];
    
    overScreenWindow = [[NSWindow alloc] initWithContentRect:theRect
                                                   styleMask:NSBorderlessWindowMask
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    [overScreenWindow setOpaque:NO];
    [overScreenWindow setHasShadow:NO];
    [overScreenWindow setBackgroundColor:[NSColor clearColor]];
    [overScreenWindow setReleasedWhenClosed:YES];
    [[overScreenWindow contentView] setWantsLayer:YES];
    
    CALayer * overWindowLayer = [[overScreenWindow contentView] layer];
    
    [self setRenderOfScreen:YES];
    [self setFrameOrigin:NSMakePoint( -16000, zoomToRect.origin.y )];
    [self makeKeyAndOrderFront:nil];
    
    CGImageRef cgImage = CGWindowListCreateImage( CGRectZero, kCGWindowListOptionIncludingWindow, [self windowNumber], kCGWindowImageDefault );
    
    CGFloat cgImageWidth = CGImageGetWidth( cgImage );
    CGFloat cgImageHeight = CGImageGetHeight( cgImage );
    
    float difWidth = ( cgImageWidth - [self frame].size.width ) / 2;
    float difHeight = ( ( cgImageHeight - [self frame].size.height ) / 2 ) + 15;
    
    CALayer * windowLayer = [CALayer layer];
    [windowLayer setFrame:CGRectMake( zoomToRect.origin.x - difWidth, ( zoomToRect.origin.y - difHeight ), cgImageWidth, cgImageHeight )];
    [windowLayer setContents:(id)cgImage];
    [windowLayer setContentsGravity:kCAGravityCenter];
    [overWindowLayer addSublayer:windowLayer];
    
    CGImageRelease( cgImage );
    
    [self setRenderOfScreen:NO];
    [self close];
    [self setFrameOrigin:zoomToRect.origin];
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    [anim setDuration:[self animationDuration]];
    [anim setFromValue:[NSNumber numberWithFloat:[self animationStartScale]]];
    [anim setToValue:[NSNumber numberWithFloat:1.0]];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [anim setRemovedOnCompletion:NO];
    [anim setAutoreverses:NO];
    [anim setFillMode:kCAFillModeForwards];
    
    [windowLayer addAnimation:anim
                       forKey:@"scaleX"];
    
    anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [anim setDuration:[self animationDuration]];
    [anim setFromValue:[NSNumber numberWithFloat:[self animationStartScale]]];
    [anim setToValue:[NSNumber numberWithFloat:1.0]];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [anim setRemovedOnCompletion:NO];
    [anim setAutoreverses:NO];
    [anim setFillMode:kCAFillModeForwards];
    [anim setDelegate:self];
    
    [windowLayer addAnimation:anim
                       forKey:@"scaleY"];
    
    [overScreenWindow makeKeyAndOrderFront:self];
    
}

#pragma mark CAAnimationDelegate

- (void)animationDidStop:(CABasicAnimation *)anim
                finished:(BOOL)flag
{
    NSDisableScreenUpdates();
    [overScreenWindow close];
    [self makeKeyAndOrderFront:nil];
    [self setIsAnimating:NO];
    NSEnableScreenUpdates();
}

@end
