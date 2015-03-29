//
//  Space_CommandAppDelegate.m
//  Space Command
//
//  Created by Nighelles David on 11/28/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "Space_CommandAppDelegate.h"
#import "SpaceCommandViewController.h"

@implementation Space_CommandAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SpaceCommandViewController *spaceController = [[SpaceCommandViewController alloc] 
                                                   initWithNibName:@"SpaceCommandViewController" bundle:nil];
    [spaceController loadView];
    [[[NSApp mainWindow] contentView] enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];

    //[spaceController showWindow:self];
}

@end
