//
//  TestBaseGlView.m
//  OpenGLESProject
//
//  Created by ct on 2017/6/15.
//  Copyright © 2017年 island. All rights reserved.
//

#import "TestBaseGlView.h"

@implementation TestBaseGlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(Class)layerClass
{
    return [CAEAGLLayer class];
}

-(const char *)getVertexShaderContent
{
    const char * vs_Content =
    "#version 300 es\n"
    "precision highp float;"
    //       "precision highp int;"
    "layout(location = 0) in vec4 position;"
    "layout(location = 1) in float point_size;"
    "uniform float is_test;"
    "flat out int test2;"
    "void main(){"
    "gl_Position = position;"
    "gl_PointSize = point_size;"
    "test2 = 1;"
    "if(is_test == 1.0){"
    "test2 = 2;"
    "}"
    "}"
    ;
    
    return vs_Content;
}

-(const char *)getFragmentShaderContext
{
    const char * fs_Content =
    "#version 300 es\n"
    "precision highp float;"
    "precision highp int;"
    "out vec4 fragColor;"
    "uniform float is_test;"
    "flat in int test2;"
    "void main(){"
    "if(is_test == 1.0 && test2 == 2 &&  length(gl_PointCoord - vec2(0.5)) > 0.5){"
    "discard;"
    "}"
    "fragColor = vec4(1.0,0.0,1.0,1.0);"
    "}";
    return fs_Content;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CALayer * layer = self.layer;
    
}

-(void)doGLOpertaion
{
    // 上传变量数据
    
    GLint numUniforms;
    GLint maxUnfiromsLen;
    char * uniformName;
    GLint index;
    
    glGetProgramiv(self.program, GL_ACTIVE_UNIFORMS, &numUniforms);
    glGetProgramiv(self.program, GL_ACTIVE_UNIFORM_MAX_LENGTH, &maxUnfiromsLen);
    
    uniformName = malloc(sizeof(char) * maxUnfiromsLen);
    
    for(index = 0; index < numUniforms; index++)
    {
        GLint size;
        GLenum type;
        GLint location;
        
        glGetActiveUniform(self.program, index, maxUnfiromsLen, NULL, &size, &type, uniformName);
        
        location = glGetUniformLocation(self.program, uniformName);
        
        
        char* str = malloc(sizeof(char) * 1);
        //        sprintf(str,"%x",9999999);
        sprintf(str, "%s","jjjjjjjjjjjjj");
        
        switch (type) {
            case GL_FLOAT:
            {
                //                GLint value = 1;
                
                  glUniform1f(location, 1.0);
//                glUniform1i(location, 1); // is error
                
                //                glUniform1f(location, GL_TRUE);
                break;
            }
                
                
            default:
                break;
        }
        
        free(str);
    }
    
    GLenum errorEnum = glGetError();
    
    NSLog(@"%d",errorEnum); // GL_NO_ERROR
    
    //    glUseProgram(program);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glClearColor(1, 1, 1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.renderbufferWidth, self.renderbufferHeight);
    
    GLfloat vertext[2];
    GLfloat size[] = {50.f};
    for(GLfloat i = -0.9; i <= 1.0; i+= 0.25f,size[0] += 20)
    {
        vertext[0] = i;//i;
        vertext[1] = 0;
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, vertext);
        
        
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 1, GL_FLOAT, GL_FALSE, 0, size);
        
        glDrawArrays(GL_POINTS, 0, 1);
        //        break;
    }
    
    
}

@end
