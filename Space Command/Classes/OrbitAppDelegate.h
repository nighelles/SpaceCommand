//
//  OrbitAppDelegate.h
//  Orbit
//
//  Created by Brian David on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrbitViewController;

@interface OrbitAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OrbitViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OrbitViewController *viewController;

@end

