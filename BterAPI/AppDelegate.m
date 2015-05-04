//
//  AppDelegate.m
//  BterAPI
//
//  Created by jianting on 14/10/10.
//  Copyright (c) 2014年 jianting. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MyViewController.h"
#import "CommonTools.h"
#import "APITabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self prepareApplicationData];
    
    ViewController *controller1 = [[ViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:controller1];
    
    MyViewController *controller2 = [[MyViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:controller2];
    
    APITabBarController *tabController = [[APITabBarController alloc] init];
    [tabController setViewControllers:[NSArray arrayWithObjects:nav1,nav2, nil] animated:YES];
    tabController.selectedIndex = 0;
    
    self.window.rootViewController = tabController;
    
    [controller1 release];
    [controller2 release];
    [nav1 release];
    [nav2 release];
    [tabController release];
    
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

#pragma mark -

- (void)prepareApplicationData
{
    [CommonTools createDirectoryIfNecessaryAtPath:[CommonTools pathForCachedTickers]];
}

@end
