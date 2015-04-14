//
//  AppDelegate.m
//  LxNavigationControllerDemo
//
//  Created by Jin on 15-4-3.
//  Copyright (c) 2015年 etiantian. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LxNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController * vc = [[ViewController alloc]init];
    LxNavigationController * nc = [[LxNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nc;
    
    return YES;
}

@end
