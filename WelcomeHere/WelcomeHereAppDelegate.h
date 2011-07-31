//
//  WelcomeHereAppDelegate.h
//  WelcomeHere
//
//  Created by Motohiro Takayama on 7/23/11.
//  Copyright 2011 deadbeaf.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelcomeHereViewController;

@interface WelcomeHereAppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL isPolling_;
    NSTimer *timer_;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) WelcomeHereViewController *viewController;

- (BOOL) needsLogin;
- (void) setVenue:(NSDictionary *)venue;

@end
