//
//  SpaceCommandViewController.m
//  Space Command
//
//  Created by Nighelles David on 11/29/11.
//  Copyright 2011 UC Berkeley. All rights reserved.
//

#import "SpaceCommandViewController.h"
#include <OpenGL/gl.h>
#include <OpenGL/OpenGL.h>
#import "Constants.h"
#import "myWindow.h"


@implementation SpaceCommandViewController
@synthesize gameView,shopView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

-(void)awakeFromNib
{
    NSRect mainDisplayRect = [[NSScreen mainScreen] frame];
    myWindow *fullScreenWindow = [[myWindow alloc] initWithContentRect: mainDisplayRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
    [fullScreenWindow setGameController:self];
    [fullScreenWindow setLevel:NSMainMenuWindowLevel+1];
    
    [fullScreenWindow setOpaque:YES];
    [fullScreenWindow setHidesOnDeactivate:YES];
    NSOpenGLPixelFormatAttribute attrs[] =
    {
        NSOpenGLPFADoubleBuffer,
        0
    };
    NSOpenGLPixelFormat* pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    
    
    SpaceCommandView *fullScreenView = [[SpaceCommandView alloc] initWithFrame:[[NSScreen mainScreen] frame] pixelFormat: pixelFormat];
    
    [self.view setFrame:[[NSScreen mainScreen] frame]];
    [gameView setFrame:[[NSScreen mainScreen] frame]];
     
    
    [fullScreenWindow setContentView: self.view];
    [fullScreenWindow makeKeyAndOrderFront:self];
}

-(void)loadView
{
    [super loadView];
    NSLog(@"View Loaded");
    //[self.view setParent:self];
    
    //[gameView setOpenGLContext:context];
    [context setView:gameView];
    glGenTextures(5, &texture[0]);
    
    up = down = left = right = FALSE;
	
    animating = FALSE;
    animationFrameInterval = 1;
    
    NSLog(@"View Loaded");
	
	//SET UP ENTITIES HERE
	
	entities = [[NSMutableArray alloc] initWithCapacity:1];
	/*
     Entity *sat2 = [[Entity alloc] init];
     sat2.y = 1200;sat2.vx = sqrt(EARTHMASS/1200);
     sat2.fuel = sat2.totalfuel = 100;
     [entities addObject:sat2];
     */
	//SET UP GRAVITY WELLS HERE
	
	gravWells = [[NSMutableArray alloc] initWithCapacity:1];
	
	
	GravityWell *earth = [[GravityWell alloc] init];
	earth.mass = EARTHMASS; // this is in kg? idk
	earth.textureID = 2;
	earth.texture = @"The Earth";
	earth.x = 0.0;earth.y = 0.0;
	earth.w = EARTHSIZE;earth.h = EARTHSIZE;
	earth.scorerate = .1;//.1;
	earth.totalscore=earth.score=500;
	earth.minscoreradius = 1500;
	earth.maxscoreradius = 1700;
	[gravWells addObject:earth];
	[entities addObject: earth];
    mearth = earth;
	
	GravityWell *moon = [[GravityWell alloc] init];
	moon.mass = MOONMASS; moon.texture = @"Earth's Moon";moon.moveable = TRUE;
	moon.x = -MOONDIST;moon.y = 0;moon.vy = sqrt(EARTHMASS/MOONDIST);
	moon.w = MOONSIZE;moon.h = MOONSIZE;
	moon.textureID = 3;
	moon.scorerate = .2;
	moon.totalscore=moon.score=500;
	moon.minscoreradius = 500;
	moon.maxscoreradius = 1000;
	[gravWells addObject:moon];
	[entities addObject:moon];
    mmoon = moon;
	
	GravityWell *mars = [[GravityWell alloc] init];
	mars.mass = MARSMASS; mars.texture = @"The Planet Mars";mars.moveable = TRUE;
	mars.textureID = 4;
	mars.x = MARSDIST;mars.y = 0;mars.vy = -sqrt(EARTHMASS/MARSDIST);
	mars.w = MARSSIZE;mars.h = MARSSIZE;
	mars.scorerate = .5;
	mars.totalscore=mars.score=1000;
	mars.minscoreradius = 750;
	mars.maxscoreradius = 950;
	[gravWells addObject:mars];
	[entities addObject:mars];
    mmars = mars;
	
	[self.view addSubview:gameView];
    
	[gameView setParent:self];

	// The player gets 200 to start with:
	
	mcash = 200;
	
	scale = 10;
	viewableArea.origin.x = -[[NSScreen mainScreen] frame].size.width/2.0*scale;
	viewableArea.origin.y = -[[NSScreen mainScreen] frame].size.height/2.0*scale;
	viewableArea.size.width = [[NSScreen mainScreen] frame].size.width*scale;
	viewableArea.size.height = [[NSScreen mainScreen] frame].size.height*scale;
	
    [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
    
    [self loadTextures];

}

- (void) keyDown:(NSEvent *)theEvent
{
   
    NSString *characters;
    characters = [theEvent characters];
    
    unichar character;
    character = [characters characterAtIndex: 0];
    if (character=='-') {
        [self scale:1.25];
        NSLog(@"Scale Down");
    }
    if (character=='=') {
        [self scale:0.75];
        NSLog(@"Scale Down");
    }
   
    
    for (Entity *ent in entities)
    {
        if (ent.selected && ent.controllable) {
            NSLog(@"Changing velocity");
            if (character=='a') {
                ent.left = TRUE;
            }
            if (character=='d') {
                ent.right = TRUE;
            }
            if (character=='w') {
                ent.up = TRUE;
            }
            if (character=='s') {
                ent.down = TRUE;
            }
        }
    }
}

-(void) keyUp:(NSEvent *)theEvent
{
    NSString *characters;
    characters = [theEvent characters];
    
    unichar character;
    character = [characters characterAtIndex: 0];
    
    for (Entity *ent in entities)
    {
        if (ent.selected && ent.controllable) {
            NSLog(@"Changing velocity");
            if (character=='a') {
                ent.left = FALSE;
            }
            if (character=='d') {
                ent.right = FALSE;
            }
            if (character=='w') {
                ent.up = FALSE;
            }
            if (character=='s') {
                ent.down = FALSE;
            }
        }
    }
}

-(void)scrollWheel:(NSEvent *)theEvent
{
    float a = 1+[theEvent deltaY];
    if (a>2) {
        a=2;
    }
    if (a<0.5) {
        a=0.5;
    }
    [self scale:a];
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    
    //NSLog(@"%f %f",[theEvent deltaX] ,[theEvent deltaY]);
	// if mouse is moving, we need to move the screen
	[self translateX:-[theEvent deltaX] Y:[theEvent deltaY]];
}

- (void) mouseDown:(NSEvent *)event
{
    NSLog(@"Mousedown logged");
	/*if ([touches count] > 1 && [[[touches allObjects] objectAtIndex:0] tapCount] == 2) {
     scale = 4;
     viewableArea.origin.x = -[[NSScreen mainScreen] frame].width/2.0*scale;
     viewableArea.origin.y = -[[NSScreen mainScreen] frame].height.0*scale;
     viewableArea.size.width = [[NSScreen mainScreen] frame].width.0*scale;
     viewableArea.size.height = 960.0*scale;
     }*/
	
	if (1 == 1) {
		CGPoint a = [event locationInWindow];
		CGPoint translatedPoint;
		
		BOOL selection = FALSE;
		for (Entity *ent in entities)
		{
			if (ent.selected && ent.moveable) selection=TRUE;
		}
		
		//MOVE A SELECTED SATELLITE HERE
		/*if (!(a.x > 50 && a.x < 280 && a.y > 50 && a.y < 430) && selection)
		{
			for (Entity *ent in entities)
			{
				if (ent.selected && ent.controllable) {
					NSLog(@"Changing velocity");
					if (a.x < 50) {
						ent.left = TRUE;
					}
					if (a.x > 280) {
						ent.right = TRUE;
					}
					if (a.y < 50) {
						ent.up = TRUE;
					}
					if (a.y > 430) {
						ent.down = TRUE;
					}
				}
			}
		}*/
		
		//translatedPoint.x = a.x*2*scale - viewableArea.size.width/2*scale +viewableArea.origin.x;
		//translatedPoint.y = ([[NSScreen mainScreen] frame].height-a.y)*2*scale - viewableArea.size.height/2*scale +viewableArea.origin.y;
		
		translatedPoint.x = scale*(a.x-[[NSScreen mainScreen] frame].size.width/2) + viewableArea.origin.x + viewableArea.size.width/2;
		translatedPoint.y = scale*(a.y-[[NSScreen mainScreen] frame].size.height/2) + viewableArea.origin.y + viewableArea.size.height/2;
		
        NSLog(@"Click at real X: %f, Y: %f",a.x,a.y);
		NSLog(@"Click at X: %f, Y: %f",translatedPoint.x,translatedPoint.y);
		BOOL f = FALSE;
		
		if (1==1) {
			for (Entity *ent in entities)
			{
				//Do click detection here
				if ([ent checkCollisionX:translatedPoint.x Y:translatedPoint.y Scale:scale]) {
					//ent.needsToDie = TRUE; DONT JUST GET RID OF THEM
					
					NSLog(@"Selected an object");
					
					for (Entity *ent2 in entities)
					{
						ent2.selected = FALSE;
					}
					ent.selected = TRUE;
					//do dynamic center object switching
					if ([ent isKindOfClass:[GravityWell class]]) {
						//NSLog(@"%@ Closest",g.texture);
						for (GravityWell *gg in gravWells)
						{
							gg.moveable = TRUE;
						}
						ent.moveable = FALSE;
						
						for (Entity *e in entities) {
							if (e != ent) {
								e.vx -= ent.vx;
								e.vy -= ent.vy;
								e.x -= ent.x;
								e.y -= ent.y;
							}
						}
						viewableArea.origin.x -= ent.x;
						viewableArea.origin.y -= ent.y;
						ent.vx = ent.vy = 0;
						ent.x = ent.y = 0;
					}
					
					if (![ent isKindOfClass:[GravityWell class]] && [event clickCount] == 2) {
						ent.following = TRUE;
					}
					else if ([event clickCount] == 2){
						if (ent.texture == @"The Earth") { // Deal with multiple shop planets later
							//handle setting up the shop window
							[self setupShop];
						}
					}
					f = 1;
				}
			}
			if (!f) {
				for (Entity *ent2 in entities)
				{
					ent2.selected = FALSE;
				}
			}
		}
	}
}


- (IBAction)createSatellite:(id)sender
{
	if (mcash >= 100) {
		mcash -= 100;
		Entity *e = [[Entity alloc] initX:0 Y:256 VX:14 VY:0 Fuel:200];
		e.textureID=0;
		e.texture = @"A Satellite";
        e.thruster = .05;
		e.destroyable = FALSE;e.launching = 100;e.controllable = FALSE;
		[entities addObject:e];
		
		[self back:self];	
	} else {
        [status setStringValue:@"You don't have enough money!"];
    }
}

- (IBAction)createLargeSatellite:(id)sender
{
	if (mcash >= 300) {
		mcash -= 300;
		Entity *e = [[Entity alloc] initX:0 Y:256 VX:14 VY:0 Fuel:100];
		e.texture = @"A Large Satellite";e.textureID=1;
		e.fuel = 600;
		e.thruster = .1;
		e.destroyable = FALSE;e.launching = 100;e.controllable = FALSE;
		[entities addObject:e];
		
		[self back:self];	
	} else {
        [status setStringValue:@"You don't have enough money!"];
    }
}

- (IBAction)createSolarSatellite:(id)sender
{
	if (mcash >= 500) {
		mcash -= 500;
		Entity *e = [[Entity alloc] initX:0 Y:256 VX:14 VY:0 Fuel:100];
		e.texture = @"A Solar Satellite";e.textureID=5;
		e.fuel = 100;
		e.thruster = .1;
		e.destroyable = FALSE;e.launching = 100;e.controllable = FALSE;e.regenerates = TRUE;e.regenerationRate=.1;
		[entities addObject:e];
		
		[self back:self];	
	} else {
        [status setStringValue:@"You don't have enough money!"];
    }
}

- (IBAction)back:(id)sender
{
	[self.view addSubview:gameView];
	[self.shopView removeFromSuperview];
	[awardView removeFromSuperview];
	[self startAnimation];
}

- (void)handleMissions
{
    if (missions[0] == 0) { //give them their first mission
        [self awardWithName:@"New Space Commander" Description:
         @"Your first mission will be to send a satellite into low earth orbit,\nWe will be giving you a grant of 200 credits to build this new satellite\nDouble Click on Earth and Select small satellite, then use wasd to steer the satellite into a stable orbit. (You'll need to select the satellite by clicking on it to center the tracking computer)" Points:200];
        missions[0] = 1;
    } else if (missions[0] == 1) {
        if ([mearth score] < [mearth totalscore]*3/4)//The earth has started to be researched
        {
            [self awardWithName:@"Research Started" Description:@"Congradulations!\nOur first satellite readings of Earth are coming in now!\nNotice how the ring around Earth turns grey as our satellites research it? That indicates how much research we can run on that planet.\nWe're transferring a bonus grant to your command center." Points:200];
            missions[0]=2;
        }
    }
    if (missions[0] == 2 && missions[1] == 0 && [mearth score] < 1)
    {
        [self awardWithName:@"Small Step" Description:@"Next, we need to gather research data on the moon. Send a large satellite to research the moon, and gather all the data you can. \n(Use the mousewheel to zoom in and out, and grab the background to pan your view)" Points:0];
        missions[1] = 1;
    } else if (missions[1] == 1) {
        for (Entity *e in entities) {
            missionEntity = e;
            if ([e texture] == @"A Large Satellite" && [mmoon getDistance:e] < 5000)
            {
                [self awardWithName:@"Tracking Computer" Description:@"Our tracking computer won't be much use out here unless you center it on the moon! (Click once on the moon to center the tracking computer, then click back to the satellite.)" Points:0];
                missions[1]=2;
            }
        }
    } else if (missions[1] == 2) {
        if ([mmoon score] < 1 && [missionEntity fuel] < [missionEntity totalfuel]*.33)
        {
            [self awardWithName:@"Well Done" Description:@"The Moon has been thouroughly researched. Well done commander. We will have another mission for you shortly" Points:200];
            missions[1]=3;
        } else if([mmoon score] < 1 && [missionEntity fuel] >= [missionEntity totalfuel]*.33) {
            [self awardWithName:@"Well Done" Description:@"The Moon has been thouroughly researched. Well done commander. If you can bring that satellite back to earth orbit, it would be a huge help in research." Points:200];
            missions[1]=3;
        }
    } else if (missions[1] == 3) {
        if ([mearth getDistance:missionEntity] < 1700 && [mearth getDistance:missionEntity] > 1500) 
            missionPoints++;
        if (missionPoints >= 50) {
            [self awardWithName:@"Welcome Home" Description:@"Bravo! That satellite is home thanks to you. We'll recover it and examine it's data." Points:200];
            missions[1] = 4;
            missionEntity = nil;
            missionPoints = 0;
        }
    }
}

- (void)awardWithName:(NSString*)name Description:(NSString*)desc Points:(CGFloat)points
{
	[self stopAnimation];
	[self.view addSubview:awardView];
    //[awardView setLayer:0];
	[self.gameView removeFromSuperview];
	
	[awardName setStringValue:name];
	[awardDesc setStringValue:[NSString stringWithFormat:@"%@\n\nAward: %f",desc,points]];
	
	mcash += points;
}

- (void)setupShop
{
	[self.view addSubview:shopView];
	[self.gameView removeFromSuperview];
	
	[cash setStringValue:[NSString stringWithFormat:@"%.2f",mcash]];
	[status setStringValue:@"Welcome to the shop!"];
	
	if (mcash >= 100) {
		[smallShipButton setEnabled:TRUE];
		[smallShipButton setAlphaValue:1];
	} else {
		
		[smallShipButton setEnabled:FALSE];
		[smallShipButton setAlphaValue:.5];
	}
	
	if (mcash >= 500) {
		[largeShipButton setEnabled:TRUE];
		[largeShipButton setAlphaValue:1];
	} else {
		[largeShipButton setEnabled:FALSE];
		[largeShipButton setAlphaValue:.5];
	}
    
	[self stopAnimation];
}



- (void)scale:(CGFloat)scaleFactor
{
	viewableArea.origin.x -= viewableArea.size.width*(scaleFactor-1)/2;
	viewableArea.origin.y -= viewableArea.size.height*(scaleFactor-1)/2;
	viewableArea.size.width *= scaleFactor;
	viewableArea.size.height *= scaleFactor;
	scale *= scaleFactor;
	NSLog(@"Scale: %f",scaleFactor);
}
- (void)translateX:(CGFloat)x Y:(CGFloat)y
{
	viewableArea.origin.x += x*scale;
	viewableArea.origin.y += y*scale;
}

- (void)rotate:(CGFloat)rot
{
	//viewableRotation += rot;
	//NSLog(@"Rotation:%f",viewableRotation);
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;
        
        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        NSTimer *aDisplayLink = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
        //Deal with fixed animation timing later
        displayLink = aDisplayLink;
        
        animating = TRUE;
    }
}


- (void)stopAnimation
{
    if (animating)
    {
        [displayLink invalidate];
        displayLink = nil;
        animating = FALSE;
    }
}


- (void)drawEntity:(Entity *)obj
{
	GLfloat squareVertices[8];
	GLfloat selectionVertices[8];
	GLfloat marginVertices[8];
	GLfloat trackVertices[100];
	GLfloat circle[90];
	GLfloat circleColors[180];
	GLfloat red[] = {
		1,0,0,1,
		1,0,0,1,
		1,0,0,1,
		1,0,0,1
	};
	GLfloat texCoords[] = {
		0.0, 1.0,
		1.0, 1.0,
		0.0, 0.0,
		1.0, 0.0
	};
	
    
	
	squareVertices[0] = obj.x-obj.w/2;
	squareVertices[1] = obj.y-obj.h/2;
	squareVertices[2] = obj.x+obj.w/2;
	squareVertices[3] = obj.y-obj.h/2;
	squareVertices[4] = obj.x-obj.w/2;
	squareVertices[5] = obj.y+obj.h/2;
	squareVertices[6] = obj.x+obj.w/2;
	squareVertices[7] = obj.y+obj.h/2;
	
	selectionVertices[0] = obj.x-obj.w/2-10*scale;
	selectionVertices[1] = obj.y-obj.h/2-10*scale;
	selectionVertices[2] = obj.x+obj.w/2+10*scale;
	selectionVertices[3] = obj.y-obj.h/2-10*scale;
	selectionVertices[6] = obj.x-obj.w/2-10*scale;
	selectionVertices[7] = obj.y+obj.h/2+10*scale;
	selectionVertices[4] = obj.x+obj.w/2+10*scale;
	selectionVertices[5] = obj.y+obj.h/2+10*scale;
    
	marginVertices[0] = -230*scale+viewableArea.origin.x+viewableArea.size.width/2;
	marginVertices[1] = -380*scale+viewableArea.origin.y+viewableArea.size.height/2;
	marginVertices[2] = -230*scale+viewableArea.origin.x+viewableArea.size.width/2;
	marginVertices[3] =  380*scale+viewableArea.origin.y+viewableArea.size.height/2;
	marginVertices[4] =  230*scale+viewableArea.origin.x+viewableArea.size.width/2;
	marginVertices[5] =  380*scale+viewableArea.origin.y+viewableArea.size.height/2;
	marginVertices[6] =  230*scale+viewableArea.origin.x+viewableArea.size.width/2;
	marginVertices[7] = -380*scale+viewableArea.origin.y+viewableArea.size.height/2;
    
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	glOrtho(viewableArea.origin.x,
            viewableArea.origin.x+viewableArea.size.width,
            viewableArea.origin.y,
            viewableArea.origin.y+viewableArea.size.height, -1.0f, 100.0f);
	glMatrixMode(GL_MODELVIEW);
	
	if (obj.textureID > -1) {
		glBindTexture(GL_TEXTURE_2D, obj.textureID); // select the already bound texture, MUCH faster
		
		glVertexPointer(2, GL_FLOAT, 0, squareVertices);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		glDisable(GL_TEXTURE_2D);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_COLOR_ARRAY);
		if (obj.w/viewableArea.size.width < .01)
        {
            glColor4f(1,1,1,.9);
            glDisableClientState(GL_COLOR_ARRAY);
			glVertexPointer(2, GL_FLOAT, 0, selectionVertices);
			glDrawArrays(GL_LINE_LOOP, 0, 4);
			glColor4f(1, 1, 1, 1);
			glEnableClientState(GL_COLOR_ARRAY);
        }
		if (obj.selected) {
			
			//do graphics for selected objects
            //fuel loss fades the bounding box to red, then grey when out
			
			if (obj.controllable) {
				glColor4f(1-pow((obj.fuel/obj.totalfuel),2), pow((obj.fuel/obj.totalfuel),2), 0, 1); // red bounding box if out
				if (obj.fuel == 0) {
					glColor4f(0.5,0.5,0.5,1);
				}
			} else {
				glColor4f(0, 0, 1, 1);
			}
            
			//glColorPointer(4, GL_FLOAT, 0, green);
			
			
			glDisableClientState(GL_COLOR_ARRAY);
			glVertexPointer(2, GL_FLOAT, 0, selectionVertices);
			glDrawArrays(GL_LINE_LOOP, 0, 4);
			glColor4f(1, 1, 1, 1);
			glEnableClientState(GL_COLOR_ARRAY);
			
			// DRAW THE MARGINS
			//glVertexPointer(2, GL_FLOAT, 0, marginVertices);
			//glColorPointer(4, GL_FLOAT, 0, red);
			//glDrawArrays(GL_LINE_LOOP, 0, 4);
			
			//Draw a predictive line
			if (obj.moveable && obj.controllable) {
				
				[obj resetPrediction];
				for (int i=0; i<50; i++) {
					[obj predict:50 GravitySources:gravWells];
					trackVertices[2*i] = obj.px;
					trackVertices[2*i+1] = obj.py;
				}
				
				glDisableClientState(GL_COLOR_ARRAY);
				glColor4f(0,1,0,1);
				glVertexPointer(2, GL_FLOAT, 0, trackVertices);
				glDrawArrays(GL_LINES, 0, 50);
				glColor4f(1, 1, 1, 1);
				glEnableClientState(GL_COLOR_ARRAY);
			}
		}
	}
	
	glDisable(GL_TEXTURE_2D);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	if ([obj isKindOfClass:[GravityWell class]]) {
		GravityWell *a = (GravityWell*)obj;
		//Draw the scoring zones for the satellites
		for (int i=0;i<45; i++) {
			circle[2*i] = cos(i*8*3.1415/180)*a.minscoreradius + a.x;
			circle[2*i+1] = sin(i*8*3.1415/180)*a.minscoreradius + a.y;
			
			if (i+1 < (a.score/a.totalscore)*45) {
				circleColors[4*i+0] = 0;
				circleColors[4*i+1] = 0;
				circleColors[4*i+2] = 1;
				circleColors[4*i+3] = 1;
			} else {
				circleColors[4*i+0] = .5;
				circleColors[4*i+1] = .5;
				circleColors[4*i+2] = .5;
				circleColors[4*i+3] = 1;
			}
            
		}
		glColorPointer(4, GL_FLOAT, 0, circleColors);
		glVertexPointer(2, GL_FLOAT, 0, circle);
		glDrawArrays(GL_LINES, 0, 45);
		glColor4f(1,1,1, 1);
		glEnableClientState(GL_COLOR_ARRAY);
		
		for (int i=0;i<45; i++) {
			circle[2*i] = cos(i*8*3.1415/180)*a.maxscoreradius + a.x;
			circle[2*i+1] = sin(i*8*3.1415/180)*a.maxscoreradius + a.y;
		}
		
		glColorPointer(4, GL_FLOAT, 0, circleColors);
		glVertexPointer(2, GL_FLOAT, 0, circle);
		glVertexPointer(2, GL_FLOAT, 0, circle);
		glDrawArrays(GL_LINES, 0, 45);
		glColor4f(1,1,1, 1);
		glEnableClientState(GL_COLOR_ARRAY);
	}
	
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
}

- (void)drawFrame
{
    [self handleMissions]; // UPDATE the storyline
    //[(EAGLView *)self.gameView setFramebuffer];
    
	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);					// Enable using textures, and set blending settings
	//glEnable(GL_LIGHTING);
	glDisable(GL_DEPTH_TEST);
	
	//glBlendFunc(GL_ONE, GL_SRC_COLOR);
	
	//glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	//GLfloat global_ambient[] = { 1.0, 1.0, 1.0, 1.0};
	//glLightModelfv(GL_LIGHT_MODEL_AMBIENT, global_ambient);
	
	//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	[cashDisplay setStringValue:[NSString stringWithFormat:@"%.2f",mcash]]; // display cash amount
	
	for (Entity *ent in entities) { //Track objects that are selected
		if (ent.selected && ent.following) {
			viewableArea.origin.x = ent.x-viewableArea.size.width/2;
			viewableArea.origin.y = ent.y-viewableArea.size.height/2;
		}
	}
	
	for (GravityWell *grav in gravWells) {

		if (grav.needsToDie) [gravWells removeObject:grav];
		for (Entity *ent in entities) {
			if (ent != grav) {
				[grav gravitize: ent];
				
				//give score for satellites that orbit planets!
				if ([grav doesScore:ent] && grav.score >= grav.scorerate) {
					mcash += grav.scorerate;
					grav.score -= grav.scorerate;
					
					/*if (grav.score == grav.totalscore-grav.scorerate) { // first time, award award
						[self awardWithName:[NSString stringWithFormat:@"Reached: %@",grav.texture] 
								Description:@"One of your satellites has taken it's first data sightings of a planet. Results are coming in now." 
									 Points:grav.totalscore/10.0];
					} else if (grav.score < grav.scorerate) {
						[self awardWithName:[NSString stringWithFormat:@"Done Researching: %@",grav.texture] 
								Description:@"You've learned all your satellites can from this planet, time to move on." 
									 Points:grav.totalscore/10.0];
					}*/ //mission system replaces this code
				}
				
				if ([grav checkCollision:ent]) {
					if (ent.destroyable) 
					{
						[entities removeObject:ent];
					}
					if (grav.destroyable) {
						[gravWells removeObject:grav];
						[entities removeObject:grav];
					}
				}
			}
		}
	}
	
	for (Entity *ent in entities) {
		if (ent.needsToDie) [entities removeObject:ent];
		[ent update];					// All entities can update during this part of the cycle
		for (Entity *ent2 in entities) {
			if (ent2 != ent && [ent checkCollision:ent2])
			{
				if (ent.destroyable) [entities removeObject:ent];
				if (ent2.destroyable) [entities removeObject:ent2];
			}
		}
	}
    
	for (GravityWell *grav in gravWells) {
		if (grav.x+grav.w/2 > viewableArea.origin.x && grav.x-grav.w/2 < viewableArea.origin.x+viewableArea.size.width &&
			grav.y+grav.h/2 > viewableArea.origin.y && grav.y-grav.h/2 < viewableArea.origin.y+viewableArea.size.height) {
			[self drawEntity:grav];
		}
	}
	for (Entity *ent in entities) {
		if (ent.selected || (ent.x+ent.w > viewableArea.origin.x && ent.x-ent.w < viewableArea.origin.x+viewableArea.size.width &&
                             ent.y+ent.h > viewableArea.origin.y && ent.y-ent.h < viewableArea.origin.y+viewableArea.size.height)) {
			[self drawEntity:ent];
		}			//Offload the work of rendering an Entity to the other func
	}
    
    glFlush();
    
}

- (void)loadTextures
{
	glBindTexture(GL_TEXTURE_2D, 0);
	[self loadTexture: @"satellite.png"];
	glBindTexture(GL_TEXTURE_2D, 1);
	[self loadTexture: @"bigsat.png"];
	glBindTexture(GL_TEXTURE_2D, 2);
	[self loadTexture: @"earth.png"];
	glBindTexture(GL_TEXTURE_2D, 3);
	[self loadTexture: @"moon.png"];
	glBindTexture(GL_TEXTURE_2D, 4);
	[self loadTexture: @"mars.png"];
    glBindTexture(GL_TEXTURE_2D, 5);
	[self loadTexture: @"solar.png"];
}

/*- (void)loadTexture: (NSString*)texName
{
	NSString *path = [[NSBundle mainBundle] pathForResource:texName ofType:@"png"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
	CGImage *image = [[ alloc] initWithData:texData];
	if (image == nil) {
		NSLog(@"Image Error");
	}
	
	GLuint width = [image size].width; //NSImageGetWidth(image);
	GLuint height = [image size].height; //NSImageGetHeight(image);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	void *imageData = malloc(height * width * 4);
	CGContextRef mcontext = CGBitmapContextCreate( imageData, width, height, 8, 4*width,
                                                  colorSpace, kCGImageAlphaPremultipliedLast |
                                                  kCGBitmapByteOrder32Big);
	CGColorSpaceRelease( colorSpace );
	CGContextClearRect( mcontext, CGRectMake(0,0,width,height));
	CGContextTranslateCTM( mcontext, 0, height - height);
	CGContextDrawImage(mcontext, CGRectMake(0,0,width,height), image);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE,imageData);
	CGContextRelease(mcontext);
	free(imageData);
	[image release];
	[texData release];
	
	return;
}*/

- (void)loadTexture: (NSString*)texName
{
    CGImageSourceRef myImageSourceRef = CGImageSourceCreateWithURL(
                            CFBundleCopyResourceURL(CFBundleGetMainBundle(), texName, NULL, NULL), NULL);
    CGImageRef myImageRef = CGImageSourceCreateImageAtIndex(myImageSourceRef, 0, NULL);
    GLint myTextureName;
    size_t width = CGImageGetWidth(myImageRef);
    size_t height = CGImageGetHeight(myImageRef);
    CGRect rect = {{0,0}, {width, height}};
    void *myData = calloc(width*4, height);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef myBitmapContext = CGBitmapContextCreate(myData, width, height, 8, width*4, space, kCGImageAlphaPremultipliedLast);
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, myImageRef);
    CGContextRelease(myBitmapContext);
    glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, myData);
    free(myData);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


/*-(void)drawFrame
{
    glClearColor(0,0,0,0);
    glClear(GL_COLOR_BUFFER_BIT);
    // DO stuff
    glFlush();
   // NSLog(@"Drew");
    [self.view drawFrame];
}*/

@end
