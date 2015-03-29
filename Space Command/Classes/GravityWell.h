//
//  GravityWell.h
//  Orbit
//
//  Created by Brian David on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface GravityWell : Entity {
	CGFloat mass;
	CGFloat minscoreradius;
	CGFloat maxscoreradius;
	CGFloat totalscore;
	CGFloat scorerate;
	CGFloat score;

}

@property (nonatomic,assign) CGFloat mass;
@property (nonatomic,assign) CGFloat minscoreradius;
@property (nonatomic,assign) CGFloat maxscoreradius;
@property (nonatomic,assign) CGFloat scorerate;
@property (nonatomic,assign) CGFloat totalscore;
@property (nonatomic,assign) CGFloat score;
- (void) gravitize:(Entity*)ent;
- (BOOL) doesScore:(Entity*)e1;
- (float) getDistance:(Entity*)ent;

@end
