//
//  GLBaseView.m
//  OpenGLESProject
//
//  Created by 吴茜 on 2017/6/14.
//  Copyright © 2017年 island. All rights reserved.
//

#import "GLBaseView.h"

@implementation GLBaseView

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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    glLayer = (CAEAGLLayer*)self.layer;  // 创建opengl 输出的视窗口
    glLayer.contentsScale = [UIScreen mainScreen].scale;
    
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]; // 创建渲染上下文
    [EAGLContext setCurrentContext:glContext];
    
    GLuint renderbuffer;
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
    
    GLint renderbufferWidth , renderbufferHeight;
    glGetRenderbufferParameteriv(renderbuffer, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(renderbuffer, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
    // 定义帧缓存
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    const char * vs_content = [self getVertexShaderContent ];
    const char * fs_content = [self getFragmentShaderContext ];
    
    GLuint vsShader = compileShader(vs_content, GL_VERTEX_SHADER);
    GLuint fsShader = compileShader(fs_content, GL_FRAGMENT_SHADER);
    
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vsShader);
    glAttachShader(program, fsShader);
    
    glLinkProgram(program);
    
    GLint linkStatus;
    glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
    if(linkStatus == GL_FALSE)
    {
        GLint logLength;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
        if(logLength > 0 )
        {
            GLchar * infoLog = malloc(sizeof(GLchar) * logLength);
            glGetProgramInfoLog(program, logLength, NULL, infoLog);
            
            printf("link program is error --> %s",infoLog);
            
            glDeleteProgram(program);
            free(infoLog);
        }
    }
    
    glUseProgram(program);
    
    
    
}

-(const char *)getVertexShaderContent
{
    return "";
}

-(const char *)getFragmentShaderContext
{
    
    return "";
}

GLuint compileShader(const char * content,GLenum shaderType)
{
    GLuint shader = glCreateShader(shaderType);
    
    glShaderSource(shader, 1, &content, NULL);
    glCompileShader(shader);
    
    
    GLint compileStatus;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
    if(compileStatus == GL_FALSE)
    {
        GLint infoLength;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLength);
        if(infoLength > 0)
        {
            GLchar * infoLog = malloc(sizeof(GLchar) * infoLength);
            glGetShaderInfoLog(shader, infoLength, NULL, infoLog);
            
            printf("compile shader error: %s -- > %s \n",shaderType == GL_VERTEX_SHADER ? "vertext shader" : "fragment shader",infoLog);
            
            free(infoLog);
        }
    }
    return shader;
}

@end
