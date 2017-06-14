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

@end

@interface GLBaseView (){
    
    CAEAGLLayer * glLayer;
    
    EAGLContext * glContext;
}

-(const char *)getVertexShaderContent;
-(const char *)getFragmentShaderContext;

@end
