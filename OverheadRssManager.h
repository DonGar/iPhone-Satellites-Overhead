//
//  OverheadRssManager.h
//  OverHead
//
//  This class fetches and parses the RSS feed of over head satellites
//  after it's started with an update location
//
//  Created by Don Garrett on 11/17/09.
//  Copyright 2009 Don Garrett. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>



@class OverheadRssManager;

@protocol OverheadRssManagerDelegate

- (void)rssManager:(OverheadRssManager *)manager didUpdate:(NSMutableArray *)newSatellites;
- (void)rssManager:(OverheadRssManager *)manager didFailWithError:(NSError *)error;

@end



@interface OverheadRssManager : NSObject {

    // How do we tell people about our results?
    id <OverheadRssManagerDelegate> delegate;

	// XML related interface
	NSXMLParser * rssParser;
	NSMutableArray * satellites;
	
	// As we parse through the RSS feed, we make temporary use of these, once per item
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;	
}

@property (retain) id <OverheadRssManagerDelegate> delegate;

- (id)init;
- (void)startRetrieving:(CLLocation *)currentLocation;
- (void)parseXMLFileAtURL:(NSString *)URL;

@end


