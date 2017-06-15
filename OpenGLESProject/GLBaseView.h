//
//  GLBaseView.h
//  OpenGLESProject
//
//  Created by 吴茜 on 2017/6/14.
//  Copyright © 2017年 island. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>

@interface GLBaseView : UIView
@property(nonatomic,retain) CAEAGLLayer * glLayer;
@property(nonatomic,retain) EAGLContext * glContext;
@property(nonatomic) GLuint program;
@property(nonatomic) GLint  renderbufferWidth;
@property(nonatomic) GLint renderbufferHeight;
@end

@interface GLBaseView (){
    
    CAEAGLLayer * glLayer;
    EAGLContext * glContext;
    GLuint  program;
    GLint  renderbufferWidth;
    GLint  renderbufferHeight;
}



-(const char *)getVertexShaderContent;
-(const char *)getFragmentShaderContext;
-(void)doGLOpertaion;
-(void)checkGLError;
@end
