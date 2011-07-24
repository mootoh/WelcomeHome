//
//  VenueViewController.m
//  WelcomeHere
//
//  Created by Motohiro Takayama on 7/24/11.
//  Copyright 2011 deadbeaf.org. All rights reserved.
//

#import "VenueViewController.h"
#import "WelcomeHereAppDelegate.h"
#import "Foursquare2.h"
#import "FoursquareWebLogin.h"
#import <CoreLocation/CoreLocation.h>

@implementation VenueViewController
@synthesize venues;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [venues release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.venues = [NSArray array];
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([Foursquare2 isNeedToAuthorize]) {
        [self authorizeWithViewController:self callback:^(BOOL success,id result){
            if (success) {
                if (! [CLLocationManager locationServicesEnabled]) {
                    NSLog(@"enable the location service!");
                }
                CLLocationManager *locationManager = [[CLLocationManager alloc] init];
                locationManager.delegate = self;
                [locationManager startUpdatingLocation];
            } else {
                // handle error.
            }
        }];
    } else {
        if (! [CLLocationManager locationServicesEnabled]) {
            NSLog(@"enable the location service!");
        }
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
}

-(void) authorizeWithViewController:(UIViewController*)controller callback:(Foursquare2Callback)callback{
	authorizeCallbackDelegate = [callback copy];
	NSString *url = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?display=touch&client_id=%@&response_type=code&redirect_uri=%@",OAUTH_KEY,REDIRECT_URL];
	FoursquareWebLogin *loginCon = [[FoursquareWebLogin alloc] initWithUrl:url];
	loginCon.delegate = self;
	loginCon.selector = @selector(setCode:);

    [controller.navigationController pushViewController:loginCon animated:YES];
    [loginCon release];
}

-(void)setCode:(NSString*)code{
	[Foursquare2 getAccessTokenForCode:code callback:^(BOOL success,id result){
		if (success) {
			[Foursquare2 setBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]];
			[Foursquare2 setAccessToken:[result objectForKey:@"access_token"]];
			authorizeCallbackDelegate(YES,result);
            [authorizeCallbackDelegate release];
		}
	}];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    [manager release];
    
    NSString *latitude  = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    NSLog(@"lat = %@, long = %@", latitude, longitude);

    [Foursquare2 searchVenuesNearByLatitude:latitude longitude:longitude accuracyLL:nil altitude:nil accuracyAlt:nil query:nil limit:nil intent:nil callback:^(BOOL success, id result){
        if (success) {
            NSDictionary *response = result;
            self.venues = [[response objectForKey:@"response"] objectForKey:@"venues"];
            [tableView reloadData];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            // should succeed...
        }
    }];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [venues count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VenueCell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *venue = [venues objectAtIndex:indexPath.row];
    cell.textLabel.text = [venue objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    WelcomeHereAppDelegate *appDelegate = (WelcomeHereAppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *venue = [venues objectAtIndex:indexPath.row];
    [appDelegate setVenue:venue];
    [self dismissModalViewControllerAnimated:YES];
}

@end
