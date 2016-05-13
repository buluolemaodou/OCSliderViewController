//
//  AppDelegate.h
//  OCSliderViewControllerDemo
//
//  Created by bingdian on 16/4/12.
//  Copyright © 2016年 bingdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSliderViewController.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,OCSliderViewControllerDelegate> {
    UIWindow *window;
}

@property (retain, nonatomic) UIWindow *window;


@end

