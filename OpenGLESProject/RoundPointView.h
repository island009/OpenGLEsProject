//
//  RoundPointView.h
//  OpenGLESProject
//
//  Created by 吴茜 on 2017/6/7.
//  Copyright © 2017年 island. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>


@interface RoundPointView : UIView

@end
@interface RoundPointView(){
    CAEAGLLayer * glLayer;
    EAGLContext * context;
}
@end
