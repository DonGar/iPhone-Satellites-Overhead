//
//  OverHeadAppDelegate.m
//  OverHead
//
//  Created by Don Garrett on 11/10/09.
//  Copyright Don Garrett 2009. All rights reserved.
//

#import "OverHeadAppDelegate.h"
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation OverHeadAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];	

	// Create a location manager instance to determine if location services are enabled. This manager instance will be
    // immediately released afterwards.
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    if (manager.locationServicesEnabled == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
    }
    [manager release];                                  	
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
