//
//  Entity.m
//  Aether
//
//  Created by Brian David on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "GravityWell.h"


@implementation Entity

@synthesize rect;
@synthesize vx;
@synthesize vy;
@synthesize x;
@synthesize y;
@synthesize px;
@synthesize py;
@synthesize pvx;
@synthesize pvy;
@synthesize w;
@synthesize h;
@synthesize texture;
@synthesize textureID;
@synthesize destroyable;
@synthesize launching;
@synthesize needsToDie;
@synthesize selected;
@synthesize controllable;
@synthesize moveable;
@synthesize following;
@synthesize fuel;
@synthesize totalfuel;
@synthesize thruster;
@synthesize up;
@synthesize down;
@synthesize left;
@synthesize right;
@synthesize regenerationRate;
@synthesize regenerates;

- (Entity*) init
{
	x = 0.0;y=0.0;
	w = 128;h=128;
	
	vx = 0.0;
	vy = 0.0;
	texture = @"satellite";
	textureID = 0;
	destroyable = TRUE;
	needsToDie = FALSE;
	selected = FALSE;
	controllable = TRUE;
	moveable = TRUE;
	following = FALSE;
	launching = 0;
	thruster = 0.1;
	fuel = 50;
    regenerates = FALSE;
	totalfuel = fuel;
	up = left = down = right;
	return self;
}

- (Entity*) initX:(CGFloat)lx Y:(CGFloat)ly VX:(CGFloat)lvx VY:(CGFloat)lvy Fuel:(CGFloat)lfuel;
{
	x = lx;y=ly;
	w = 128;h=128;
	
	vx = lvx;
	vy = lvy;
	texture = @"";
	destroyable = TRUE;
	launching = 0;
	needsToDie = FALSE;
	selected = FALSE;
	controllable = TRUE;
	moveable = TRUE;
	following = FALSE;
	thruster = 0.1;
	fuel = lfuel;
	totalfuel = fuel;
	up = left = down = right;
    
    regenerates=FALSE;
    regenerationRate = 0;
	return self;
}

- (void) update
{
	if (launching > 0) {
		launching -= 1;
		if (launching == 1) {
			destroyable = TRUE;
			controllable = TRUE;
		}
	}
	if (moveable) {
		self.x += self.vx;
		self.y += self.vy;
	}
	if (!selected && following) {
		following = FALSE;
	}
	if (fuel > 0 && moveable) {
		if (up) {
			vy += thruster;fuel-=1;
		}
		if (down) {
			vy -= thruster;fuel-=1;
		}
		if (left) {
			vx -= thruster;fuel-=1;
		}
		if (right) {
			vx += thruster;fuel-=1;
		}
	}
    if (regenerates) {
        fuel += regenerationRate;
    }
	//NSLog(@"X: %f, Y: %f, VX: %f, VY:%f\n",x,y,vx,vy);
}

- (void) resetPrediction
{
	px = x; pvx = vx;
	py = y; pvy = vy;
}

- (void) predict:(int) ticks GravitySources:(NSArray *)gravSources
{
	for (int i=0; i<ticks; i++) {
		for (GravityWell *g in gravSources) {
			CGFloat d = sqrt(pow(g.y-py, 2) + pow(g.x-px, 2));
			CGFloat f = g.mass;
			if (d > 1) {
				pvx += f*((g.x - px)/(d*d*d));
				pvy += f*((g.y - py)/(d*d*d));
			}
		}
		px += pvx;
		py += pvy;
	}
}

- (BOOL) checkCollision:(Entity*)ent
{
	float d = sqrt(pow(ent.x-x, 2) + pow(ent.y-y, 2));
	if (d > ent.w/2+w/2) {
		return FALSE;
	} else {
		return TRUE;
		NSLog(@"Collision!\n");
	}
}

- (BOOL) checkCollisionX:(CGFloat)lx Y:(CGFloat)ly Scale:(CGFloat) scale
{
	if (lx > x+w/2+scale*10 || lx < x-w/2-scale*10 || ly > y+h/2+scale*10 || ly < y-h/2-scale*10) {
		//NSLog(@"Scale: %f, MOE: %f",scale,50*scale);
		return FALSE;
	} else {
		return TRUE;
	}
}

- (void)die
{
	needsToDie = TRUE;
}
@end
