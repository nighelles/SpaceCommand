//
//  myWindow.h
//  Space Command
//
//  Created by Nighelles David on 11/29/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface myWindow : NSWindow
{
    IBOutlet NSViewController* gameController;
}
@property(nonatomic,retain) NSViewController* gameController;
@end
