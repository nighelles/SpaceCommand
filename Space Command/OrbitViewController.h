//
//  AetherViewController.h
//  Aether
//
//  Created by Brian David on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <OpenGL/GL.h>
#import <QuartzCore/QuartzCore.h>

#import <OpenGL/gl.h>
#import <OpenGL/glext.h>

#import "Entity.h"
#import "GravityWell.h"

@class EAGLView;

@interface OrbitViewController : NSViewController
{
    NSOpenGLContext *context;
    GLuint program;
    
    BOOL animating;
    NSInteger animationFrameInterval;
    NSTimer *displayLink;
	
	CGRect viewableArea;
	
	GLuint texture[1];
	GLfloat scale;
	GLfloat viewableRotation;
	BOOL up,down,left,right;
	
	NSMutableArray *entities; // All entities that will be gravitized
	NSMutableArray *gravWells; // List of entities that supply gravity
	
	CGFloat offset;

	CGFloat mcash;
	
	IBOutlet NSView *shopView;
	IBOutlet NSOpenGLView *gameView;
	IBOutlet NSView *awardView;
	
	IBOutlet NSTextField *cash;
	IBOutlet NSTextField *status;
	IBOutlet NSButton *smallShipButton;
	IBOutlet NSButton *largeShipButton;
	IBOutlet NSTextField *cashDisplay;
	
	IBOutlet NSTextField *awardName;
	IBOutlet NSTextField *awardDesc;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@property (nonatomic,assign) CGFloat offset;

- (void)startAnimation;
- (void)stopAnimation;
- (void)scale:(CGFloat)scaleFactor;
- (void)translateX:(CGFloat)x Y:(CGFloat)y;
- (void)rotate:(CGFloat)rot;
- (IBAction)createSatellite:(id)sender;
- (IBAction)createLargeSatellite:(id)sender;
- (IBAction)back:(id)sender;
- (void)setupShop;
- (void)viewDidLoad;

@end
