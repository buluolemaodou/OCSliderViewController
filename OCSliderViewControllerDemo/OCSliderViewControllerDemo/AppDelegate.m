//
//  AppDelegate.m
//  OCSliderViewControllerDemo
//
//  Created by bingdian on 16/4/12.
//  Copyright © 2016年 bingdian. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

#pragma mark - OCSliderViewController delegate

//- (void)OCSliderViewController:(OCSliderViewController *)ocSliderViewController
//     didSliderToViewController:(UIViewController *)viewController {
//    NSLog(@"=================********* didSliderToViewController ***********================");
//}
//
//- (BOOL)OCSliderViewController:(OCSliderViewController *)ocSliderViewController shouldSlideToViewController:(UIViewController *)viewController {
//    NSLog(@"=================********* shouldSliderToViewController ***********================");
//    return YES;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
    
    OCSliderViewController *svc = [[OCSliderViewController alloc] init];
    window.rootViewController = svc;
    [svc release];

    ViewController *vc = [[ViewController alloc] init];
    vc.ocSliderBarTitle = @"首页";
    
    ViewController *vc2 = [[ViewController alloc] init];
    vc2.ocSliderBarTitle = @"我的";

    ViewController *vc3 = [[ViewController alloc] init];
    vc3.ocSliderBarTitle = @"其它";

    ViewController *vc4 = [[ViewController alloc] init];
    vc4.ocSliderBarTitle = @"新增";

    ViewController *vc5 = [[ViewController alloc] init];
    vc5.ocSliderBarTitle = @"购买";

    ViewController *vc6 = [[ViewController alloc] init];
    vc6.ocSliderBarTitle = @"增加";

    svc.childViewControllers = @[vc,vc2,vc3,vc4,vc5,vc6];
    
    [vc release];
    [vc2 release];
    [vc3 release];
    [vc4 release];
    [vc5 release];
    [vc6 release];
    
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
