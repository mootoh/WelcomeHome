//
//  VenueViewController.h
//  WelcomeHere
//
//  Created by Motohiro Takayama on 7/24/11.
//  Copyright 2011 deadbeaf.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foursquare2.h"
#import <CoreLocation/CoreLocation.h>

@interface VenueViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    Foursquare2Callback authorizeCallbackDelegate;
    NSArray *venues;
    IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSArray *venues;

-(void)authorizeWithViewController:(UIViewController*)controller callback:(Foursquare2Callback)callback;
-(void)setCode:(NSString*)code;

@end
