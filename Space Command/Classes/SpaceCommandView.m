//
//  SpaceCommandView.m
//  Space Command
//
//  Created by Nighelles David on 11/28/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "SpaceCommandView.h"
#include <OpenGL/gl.h>
#include <OpenGL/OpenGL.h>

@implementation SpaceCommandView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)setParent:(NSViewController*)controller
{
    parent = controller;
}
-(void)mouseDragged:(NSEvent *)theEvent
{
    [parent mouseDragged:theEvent];
}
-(void)mouseDown:(NSEvent *)theEvent
{
    [parent mouseDown:theEvent];
    //NSLog(@"Got to the view");
}
-(void)scrollWheel:(NSEvent *)theEvent
{
    [parent scrollWheel:theEvent];
}
-(void)keyDown:(NSEvent *)theEvent:(NSEvent *)theEvent
{
    [parent keyDown:theEvent];
    NSLog(@"Keydown logged");
}

-(void)keyUp:(NSEvent *)theEvent:(NSEvent *)theEvent
{
    [parent keyUp:theEvent];
    //NSLog(@"Got to the view");
}

- (BOOL)acceptsFirstResponder {
    return YES;
}
- (BOOL)becomeFirstResponder {
    return YES;
}

-(void) drawFrame
{
    //
}

@end
