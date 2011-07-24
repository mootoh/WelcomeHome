//
//  WelcomeHereViewController.m
//  WelcomeHere
//
//  Created by Motohiro Takayama on 7/23/11.
//  Copyright 2011 deadbeaf.org. All rights reserved.
//

#import "WelcomeHereViewController.h"
#import "VenueViewController.h"

@implementation WelcomeHereViewController
@synthesize venue;
@synthesize peopleNow, peoplePast;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc
{
    [venue release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    venue = nil;
    self.peopleNow  = [NSArray array];
    self.peoplePast = [NSArray array];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void) setVenue:(NSDictionary *)venue_
{
    venue = [venue_ retain];
    NSString *venueID = [venue objectForKey:@"id"];

    self.title = [venue objectForKey:@"name"];

    [Foursquare2 getVenueHereNow:venueID limit:nil offset:nil afterTimestamp:nil callback:^(BOOL success, id result) {
        if (success) {
            NSDictionary *response = (NSDictionary *)result;
            self.peopleNow = [[[response objectForKey:@"response"] objectForKey:@"hereNow"] objectForKey:@"items"];
            [peopleNowTableView reloadData];
        }
    }];
}

- (IBAction) showVenuSelection
{
    VenueViewController *vvc = [[VenueViewController alloc] initWithNibName:@"VenueViewController" bundle:nil];
    UINavigationController *navigacionController = [[UINavigationController alloc] initWithRootViewController:vvc];
    navigacionController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:navigacionController animated:NO];
}

#pragma mark TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (! venue) return 0;

    if (tableView == peopleNowTableView)
        return [peopleNow count];
    return [peoplePast count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckinCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (tableView == peopleNowTableView) {
        NSDictionary *user = [[peopleNow objectAtIndex:indexPath.row] objectForKey:@"user"];
        cell.textLabel.text = [user objectForKey:@"firstName"];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[user objectForKey:@"photo"]]];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        if (error == nil) {
            cell.imageView.image = [UIImage imageWithData:responseData];
        }
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    WelcomeHereAppDelegate *appDelegate = (WelcomeHereAppDelegate *)[UIApplication sharedApplication].delegate;
//    NSDictionary *venue = [venues objectAtIndex:indexPath.row];
//    [appDelegate setVenue:venue];
//    [self dismissModalViewControllerAnimated:YES];
//}

@end
