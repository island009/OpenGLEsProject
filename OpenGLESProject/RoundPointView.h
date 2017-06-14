//
//  RoundPointView.h
//  OpenGLESProject
//
//  Created by 吴茜 on 2017/6/7.
//  Copyright © 2017年 island. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>


@interface RoundPointView : UIView

@end
@interface RoundPointView(){
    CAEAGLLayer * glLayer;
    EAGLContext * context;
}
@end
