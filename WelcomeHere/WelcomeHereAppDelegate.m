//
//  WelcomeHereAppDelegate.m
//  WelcomeHere
//
//  Created by Motohiro Takayama on 7/23/11.
//  Copyright 2011 deadbeaf.org. All rights reserved.
//

#import "WelcomeHereAppDelegate.h"
#import "WelcomeHereViewController.h"
#import "Foursquare2.h"

@implementation WelcomeHereAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    isPolling_ = NO;
    timer_ = nil;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[WelcomeHereViewController alloc] initWithNibName:@"WelcomeHereViewController" bundle:nil]; 
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    if ([self needsLogin]) {
        [self.viewController showVenuSelection];
    }
    
    return YES;
}

- (BOOL) needsLogin
{
    return [Foursquare2 isNeedToAuthorize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL) isPolling
{
    return isPolling_;
}

- (void) startPolling
{
    timer_ = [[NSTimer timerWithTimeInterval:60 target:self.viewController selector:@selector(updateVenuPeople) userInfo:nil repeats:YES] retain];
    [[NSRunLoop mainRunLoop] addTimer:timer_ forMode:NSDefaultRunLoopMode];
    isPolling_ = YES;
}

- (void) stopPolling
{
    if (timer_) {
        [timer_ invalidate];
        [timer_ release];
        timer_ = nil;
    }

    isPolling_ = NO;
}

- (void) setVenue:(NSDictionary *)venue
{
    if ([self isPolling])
        [self stopPolling];

    // save the venue into the persistent storage
    [self.viewController setVenue:venue];

    // start polling for new visitors
    [self startPolling];
}

@end
