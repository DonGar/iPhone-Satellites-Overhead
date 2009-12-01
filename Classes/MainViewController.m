//
//  MainViewController.m
//  OverHead
//
//  Created by Don Garrett on 11/10/09.
//  Copyright Don Garrett 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"


@implementation MainViewController


@synthesize locationManager;
@synthesize location;
@synthesize rssManager;
@synthesize satellites;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
		
    MainView *mainView = (MainView *)self.view;    
    mainView.controller = self;
    
	// Allocate RSS manager, but don't start it until we get a location
	self.rssManager = [[[OverheadRssManager alloc] init] autorelease];
    rssManager.delegate = self;
	
	// Allocate GPS manager
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    
    // http://orbitingfrog.com/blog/over-twitter/ says 20 miles is close enough 32k meters == 20 miles
    locationManager.desiredAccuracy = 32186.88;
    locationManager.distanceFilter = locationManager.desiredAccuracy / 2;
	
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
	
	// Never waste battery spending more than 60 seconds figuring out where we are
    [self performSelector:@selector(stopUpdatingLocation:) withObject:nil afterDelay:60];

	[self refreshView];
}

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	location = newLocation;

	[rssManager startRetrieving:newLocation];    
    [self refreshView];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}


/*
 * This method is called on a timer to keep the GPS from running forever
 */
- (void)stopUpdatingLocation:(id)arg {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    
    if (!location) {
        NSString * errorString = @"Timed out attempting to discover the current location.";
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error getting location" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
}


/*
 * The RSS manager told us about a new set of results
 */
- (void)rssManager:(OverheadRssManager *)manager didUpdate:(NSMutableArray *)newSatellites {

    satellites = newSatellites;
    [self refreshView];
}


/*
 * The RSS manager error'd out fetching results
 */
- (void)rssManager:(OverheadRssManager *)manager didFailWithError:(NSError *)error {
    
    [self refreshView];

	NSString * errorString = [NSString stringWithFormat:@"Unable to fetch satellite information (Error code %i )", [error code]];
	NSLog(@"error parsing XML: %@", errorString);
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error fetching data" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)refreshView {
    
    MainView *mainView = (MainView *)self.view;    
	
    [mainView refreshView];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
