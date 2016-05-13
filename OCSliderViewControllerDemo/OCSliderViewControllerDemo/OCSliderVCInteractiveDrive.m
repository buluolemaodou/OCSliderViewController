//
//  OCSliderVCInteractiveDrive.m
//  OCSliderViewControllerDemo
//
//  Created by bingdian on 16/4/29.
//  Copyright © 2016年 bingdian. All rights reserved.
//

#import "OCSliderVCInteractiveDrive.h"

@interface OCSliderVCInteractiveDrive (){
    id<UIViewControllerContextTransitioning> transitionContext;
}

@end

@implementation OCSliderVCInteractiveDrive

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)aTransitionContext {
    transitionContext = aTransitionContext;
    transitionContext.containerView.layer.speed = 0.0;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    [transitionContext updateInteractiveTransition:percentComplete];
}

- (void)cancelInteractiveTransition {
    [transitionContext cancelInteractiveTransition];
}

- (void)finishInteractiveTransition {
    [transitionContext finishInteractiveTransition];
}

- (void)dealloc {
    [super dealloc];
    NSLog(@"OCSliderVCInteractiveDrive被销毁了");
}

@end
