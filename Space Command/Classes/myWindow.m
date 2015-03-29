//
//  myWindow.m
//  Space Command
//
//  Created by Nighelles David on 11/29/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "myWindow.h"

@implementation myWindow
@synthesize gameController;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) keyDown:(NSEvent *)theEvent
{
    [gameController keyDown:theEvent];
    NSLog(@"At least this works");
}

-(void) keyUp:(NSEvent *)theEvent
{
    [gameController keyUp:theEvent];
    NSLog(@"At least this works");
}


@end
