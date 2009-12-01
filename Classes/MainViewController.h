//
//  MainViewController.h
//  OverHead
//
//  Created by Don Garrett on 11/10/09.
//  Copyright Don Garrett 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "OverheadRssManager.h"
#import <CoreLocation/CoreLocation.h>


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,CLLocationManagerDelegate,OverheadRssManagerDelegate> {
	    
	// GPS related
	CLLocationManager *locationManager;
	CLLocation *location;
	
    // RSS related
	OverheadRssManager *rssManager;
    NSMutableArray * satellites;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *location;

@property (nonatomic, retain) OverheadRssManager *rssManager;
@property (nonatomic, retain) NSMutableArray * satellites;


- (void)stopUpdatingLocation:(NSString *)state;

// General UI
- (void)refreshView;
- (IBAction)showInfo;

@end
