//
//  GravityWell.m
//  Orbit
//
//  Created by Brian David on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GravityWell.h"
#import <math.h>


@implementation GravityWell
@synthesize mass;
@synthesize minscoreradius;
@synthesize maxscoreradius;
@synthesize scorerate;
@synthesize totalscore;
@synthesize score;


- (GravityWell*) init
{
	x = 0.0;y=0.0;
	w = 128.0;h=128.0;
	vx = 0.0;
	vy = 0.0;
	mass = 10;
	texture = @"";
	selectedTexture = @"";
	destroyable=FALSE;
	controllable=FALSE;
	moveable=FALSE;
	minscoreradius=1000;
	maxscoreradius=1200;
	scorerate=.1;
	score=100;
	totalscore = 100;

	
	return self;
}

- (void) gravitize:(Entity*)ent
{
	CGFloat d = sqrt(pow(y-ent.y, 2) + pow(x-ent.x, 2));
	CGFloat f = mass;
	if (d > 1) {
		ent.vy += f*((y - ent.y)/(d*d*d));
		ent.vx += f*((x - ent.x)/(d*d*d));
	}
	//NSLog(@"%@ Applied an accelleration of X:%f, Y:%f to %@",texture,((x - ent.x))/(d*d*d)*f,((y - ent.y))/(d*d*d)*f,ent.texture);
}
- (float) getDistance:(Entity*)ent
{
    return sqrt(pow(y-ent.y, 2) + pow(x-ent.x, 2));
}

- (BOOL)doesScore:(Entity*)e1
{
	float d = sqrt(pow(e1.x-x, 2)+pow(e1.y-y, 2));
	if (d > minscoreradius && d < maxscoreradius) {
		return TRUE;
	} else {
		return FALSE;
	}
}


@end
