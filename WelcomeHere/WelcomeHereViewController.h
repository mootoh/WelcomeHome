//
//  WelcomeHereViewController.h
//  WelcomeHere
//
//  Created by Motohiro Takayama on 7/23/11.
//  Copyright 2011 deadbeaf.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeHereViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary *venue;
    NSArray *peopleNow;
    NSArray *peoplePast;

    IBOutlet UITableView *peopleNowTableView;
    IBOutlet UITableView *peoplePastTableView;
}

@property (nonatomic, retain) NSDictionary *venue;
@property (nonatomic, retain) NSArray *peopleNow;
@property (nonatomic, retain) NSArray *peoplePast;

- (IBAction) showVenuSelection;
- (void) updateVenuPeople;

@end
