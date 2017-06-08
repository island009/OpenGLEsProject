//
//  MyGLView.m
//  OpenGLESProject
//
//  Created by ct on 2017/6/7.
//  Copyright © 2017年 island. All rights reserved.
//

#import "MyGLView.h"
#define VERTEX_POS_INDX 0
#define NUM_FACES 6

@implementation MyGLView

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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        [EAGLContext setCurrentContext:context];
        
        printf("厂家 %s\n",glGetString(GL_VENDOR));
        printf("渲染器 %s\n",glGetString(GL_RENDERER));
        printf("es版本 %s\n",glGetString(GL_VERSION));
        
        printf("扩展功能 %s\n",glGetString(GL_EXTENSIONS));
        
        
        GLuint renderbuffer;
        glGenRenderbuffers(1, &renderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
        
        
        GLuint framebuffer;
        glGenFramebuffers(1, &framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,  renderbuffer);
        
        glClearColor(1, 0, 1, 1);
        
        glClear(GL_COLOR_BUFFER_BIT);
        
        
        
        
//        GLfloat vertices[] = {};
//        glEnableVertexAttribArray(VERTEX_POS_INDX);
//        
//        glVertexAttribPointer(VERTEX_POS_INDX, 3, GL_FLOAT, GL_FALSE, 0, vertices);  //像定点着色器传递顶点数据。
//        
//        for(int i = 0; i < NUM_FACES; i++)
//        {
//            glDrawArrays(GL_TRIANGLE_FAN, i * 4, 4);   //这里必须要写 shader ，
//        }
        
        [context presentRenderbuffer:GL_RENDERBUFFER];
    }
    return self;
}



@end
