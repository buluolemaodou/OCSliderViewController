//
//  ViewController.m
//  OCSliderViewControllerDemo
//
//  Created by bingdian on 16/5/13.
//  Copyright © 2016年 bingdian. All rights reserved.
//

#import "ViewController.h"
#import "OCSliderViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = self.ocSliderBarTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.exclusiveTouch = YES;
    label.font = [UIFont systemFontOfSize:20.0];
    [self.view addSubview:label];
    [label release];
}

@end
