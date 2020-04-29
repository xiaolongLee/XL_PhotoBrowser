//
//  AppDelegate.m
//  图片浏览器
//
//  Created by 李小龙 on 2020/4/29.
//  Copyright © 2020 李小龙. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *root = [ViewController new];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    return YES;
}




@end
