//
//  SpaceCommandView.h
//  Space Command
//
//  Created by Nighelles David on 11/28/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "SpaceCommandViewController.h"

@interface SpaceCommandView : NSOpenGLView
{
    NSViewController *parent;
}
- (void)drawFrame;
@end
