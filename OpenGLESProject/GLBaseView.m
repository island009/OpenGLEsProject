//
//  GLBaseView.m
//  OpenGLESProject
//
//  Created by 吴茜 on 2017/6/14.
//  Copyright © 2017年 island. All rights reserved.
//

#import "GLBaseView.h"

@implementation GLBaseView
@synthesize glLayer,glContext,program,renderbufferWidth,renderbufferHeight;

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
    
    self.glLayer = (CAEAGLLayer*)self.layer;  // 创建opengl 输出的视窗口
    self.glLayer.contentsScale = [UIScreen mainScreen].scale;
    
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]; // 创建渲染上下文
    [EAGLContext setCurrentContext:self.glContext];
    
    GLuint renderbuffer;
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    
    [self checkGLError];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
    [self checkGLError];
    
    // 定义帧缓存
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    const char * vs_content = [self getVertexShaderContent ];
    const char * fs_content = [self getFragmentShaderContext ];
    
    GLuint vsShader = compile_Shader(vs_content, GL_VERTEX_SHADER);
    GLuint fsShader = compile_Shader(fs_content, GL_FRAGMENT_SHADER);
    
    
    self.program = glCreateProgram();
    glAttachShader(self.program, vsShader);
    glAttachShader(self.program, fsShader);
    
    glLinkProgram(self.program);
    
    GLint linkStatus;
    glGetProgramiv(self.program, GL_LINK_STATUS, &linkStatus);
    if(linkStatus == GL_FALSE)
    {
        GLint logLength;
        glGetProgramiv(self.program, GL_INFO_LOG_LENGTH, &logLength);
        if(logLength > 0 )
        {
            GLchar * infoLog = malloc(sizeof(GLchar) * logLength);
            glGetProgramInfoLog(self.program, logLength, NULL, infoLog);
            
            printf("link program is error --> %s",infoLog);
            
            glDeleteProgram(self.program);
            free(infoLog);
        }
    }
    
    glUseProgram(self.program);
    
    [self checkGLError];
    
    
    [self doGLOpertaion];
    
    [self checkGLError];
    
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)checkGLError
{
    GLenum errorEnum = glGetError();
    switch (errorEnum) {
        case GL_NO_ERROR:
            
            NSLog(@"OpengGL is not error");
            
            break;
        case GL_INVALID_ENUM:
            NSLog(@"GL Error GL_INVALID_ENUM");
            break;
        case GL_INVALID_VALUE:
            NSLog(@"GL Error GL_INVALID_VALUE");
            break;
        case GL_INVALID_OPERATION:
            NSLog(@"GL Error GL_INVALID_OPERATION");
            break;
        case GL_OUT_OF_MEMORY:
            NSLog(@"GL Error GL_OUT_OF_MEMORY");
            break;
        case GL_INVALID_FRAMEBUFFER_OPERATION:
            NSLog(@"GL Error GL_INVALID_FRAMEBUFFER_OPERATION");
            break;
        default:
            NSLog(@"GL Error no catch errorEnum = %d",errorEnum);
            break;
    }
    
}

-(void)doGLOpertaion
{
    
}

-(const char *)getVertexShaderContent
{
    return "";
}

-(const char *)getFragmentShaderContext
{
    
    return "";
}

GLuint compile_Shader(const char * content,GLenum shaderType)
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
