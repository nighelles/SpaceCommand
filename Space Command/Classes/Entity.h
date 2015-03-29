//
//  Entity.h
//  Aether
//
//  Created by Brian David on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>

@interface Entity : NSObject {
	CGFloat x;
	CGFloat y;
	CGFloat w;
	CGFloat h;
	
	CGFloat vx;
	CGFloat vy;
	
	CGFloat px;
	CGFloat py;
	CGFloat pvx;
	CGFloat pvy;
	
	NSString* texture;
	NSString* selectedTexture;
	int textureID;
	
	CGFloat fuel;
	CGFloat totalfuel;
	CGFloat thruster;
	
	CGFloat launching;
	
    CGFloat regenerationRate;
    BOOL regenerates;
    
	BOOL destroyable;
	BOOL needsToDie;
	BOOL selected;
	BOOL controllable;
	BOOL moveable;
	BOOL following;
	BOOL up;
	BOOL down;
	BOOL left;
	BOOL right;
}
@property(nonatomic, assign) CGRect rect;
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat px;
@property(nonatomic, assign) CGFloat py;
@property(nonatomic, assign) CGFloat pvx;
@property(nonatomic, assign) CGFloat pvy;
@property(nonatomic, assign) CGFloat w;
@property(nonatomic, assign) CGFloat h;
@property(nonatomic, assign) CGFloat vx;
@property(nonatomic, assign) CGFloat vy;
@property(nonatomic, assign) CGFloat fuel;
@property(nonatomic, assign) CGFloat totalfuel;
@property(nonatomic, assign) CGFloat thruster;
@property(nonatomic, assign) CGFloat launching;
@property(nonatomic, retain) NSString* texture;
@property(nonatomic, retain) NSString* selectedTexture;
@property(nonatomic, assign) int textureID;
@property(nonatomic, assign) CGFloat regenerationRate;
@property(nonatomic, assign) BOOL regenerates;
@property(nonatomic, assign) BOOL destroyable;
@property(nonatomic, assign) BOOL needsToDie;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, assign) BOOL controllable;
@property(nonatomic, assign) BOOL moveable;
@property(nonatomic, assign) BOOL following;
@property(nonatomic, assign) BOOL up;
@property(nonatomic, assign) BOOL down;
@property(nonatomic, assign) BOOL left;
@property(nonatomic, assign) BOOL right;

- (Entity*) init;
- (Entity*) initX:(CGFloat)lx Y:(CGFloat)ly VX:(CGFloat)lvx VY:(CGFloat)lvy Fuel:(CGFloat)lfuel;
- (void) update;
- (void) resetPrediction;
- (void) predict:(int)ticks GravitySources:(NSArray *)gravSources;
- (BOOL) checkCollision:(Entity*)ent;
- (BOOL) checkCollisionX:(CGFloat)lx Y:(CGFloat)ly Scale:(CGFloat)scale;
- (void) die;
@end
