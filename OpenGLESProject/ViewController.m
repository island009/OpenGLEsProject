//
//  ViewController.m
//  OpenGLESProject
//
//  Created by ct on 2017/6/7.
//  Copyright © 2017年 island. All rights reserved.
//

#import "ViewController.h"
#import "MyGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect viewSize = [[UIScreen mainScreen] bounds];
    
    CGRect frameRect = CGRectMake(0, 0, viewSize.size.width , viewSize.size.height);
    MyGLView * glView = [[MyGLView alloc] initWithFrame:frameRect];
    [self.view addSubview:glView];
    
//    [glView setBackgroundColor:[UIColor blackColor]];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
