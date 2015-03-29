//
//  EAGLView.h
//  Orbit
//
//  Created by Brian David on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#import "OrbitViewController.h"

// This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
// The view content is basically an EAGL surface you render your OpenGL scene into.
// Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
@interface EAGLView : UIView
{
@private
    GLContext *context;
    
    // The pixel dimensions of the CAEAGLLayer.
    GLint framebufferWidth;
    GLint framebufferHeight;
    
	OrbitViewController *parent;
	
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view.
    GLuint defaultFramebuffer, colorRenderbuffer;
}

@property (nonatomic, retain) EAGLContext *context;

- (void)setFramebuffer;
- (BOOL)presentFramebuffer;
- (void)setParent:(OrbitViewController*)p;

@end
