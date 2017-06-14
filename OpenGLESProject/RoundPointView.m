//
//  RoundPointView.m
//  OpenGLESProject
//
//  Created by 吴茜 on 2017/6/7.
//  Copyright © 2017年 island. All rights reserved.
//

#import "RoundPointView.h"

@implementation RoundPointView

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
    
    
    glLayer = (CAEAGLLayer*)self.layer;
    glLayer.contentsScale = [UIScreen mainScreen].scale;
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    
    GLuint renderbuffer;
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
    
    
    GLint renderbufferWidth,renderbufferHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &renderbufferHeight);
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);
    
    const char * vertextShaderContent =
       "#version 300 es\n"
       "precision highp float;"
//       "precision highp int;"
       "layout(location = 0) in vec4 position;"
       "layout(location = 1) in float point_size;"
        "uniform int is_test;"
       "flat out int test2;"
    
       "void main(){"
          "gl_Position = position;"
          "gl_PointSize = point_size;"
//          "test2 = 3;"
       "}"
    ;
    
    const char * vs_uniform =
    "#version 300 es \n"
    "layout(location = 0) in vec4 position;\n"
    "layout(location = 1) in float point_size;\n"
    "uniform bool test;\n"
    "void main(){"
        "gl_Position = position;"
        "gl_PointSize = point_size;"
    "}"
    ;
    
    GLuint vertextShader = compileShader(vs_uniform,GL_VERTEX_SHADER);
    
    const char * fs_uniform =
    "#version 300 es \n"
    "precision highp float;\n"
    "out vec4 fragColor;\n"
    "uniform bool test\n;"
    "void main(){"
       "fragColor = vec4(1.0,0.0,1.0,1.0);"
    "}";
    
    GLuint fargmentShader = compileShader(fs_uniform, GL_FRAGMENT_SHADER);
    
    GLuint program = glCreateProgram();
    glAttachShader(program, vertextShader);
    glAttachShader(program, fargmentShader);
    
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
    
    // 上传变量数据
    
    GLint numUniforms;
    GLint maxUnfiromsLen;
    char * uniformName;
    GLint index;
    glGetProgramiv(program, GL_ACTIVE_UNIFORMS, &numUniforms);
    glGetProgramiv(program, GL_ACTIVE_UNIFORM_MAX_LENGTH, &maxUnfiromsLen);
    
    uniformName = malloc(sizeof(char) * maxUnfiromsLen);
    
    for(index = 0; index < numUniforms; index++)
    {
        GLint size;
        GLenum type;
        GLint location;
        
        glGetActiveUniform(program, index, maxUnfiromsLen, NULL, &size, &type, uniformName);
        
        location = glGetUniformLocation(program, uniformName);
        
        switch (type) {
            case GL_BOOL:
            case GL_INT:
                
                glUniform1i(location, 1);
                
//                glUniform1f(location, GL_TRUE);
                break;
                
            default:
                break;
        }
    }
    
    
    glUseProgram(program);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glClearColor(1, 1, 1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, renderbufferWidth, renderbufferHeight);
    
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
    
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

GLuint compileShader(const char * shaderContent,GLenum shaderType)
{
    GLuint shader = glCreateShader(shaderType);
    glShaderSource(shader, 1, &shaderContent, NULL);
    glCompileShader(shader);
    
    GLint complieStatus;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &complieStatus);
    if(complieStatus == GL_FALSE)
    {
        GLint infoLength;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLength);
        if(infoLength > 0)
        {
            GLchar * infoLog = malloc(sizeof(GLchar)* infoLength);
            glGetShaderInfoLog(shader, infoLength, NULL, infoLog);
            
            printf("%s -- > %s \n",shaderType == GL_VERTEX_SHADER ? "vertext shader" : "fargment shader",infoLog);
            
            free(infoLog);
        }
    }
    
    return shader;
    
}


@end

