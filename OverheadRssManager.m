//
//  OverheadRssManager.m
//  OverHead
//
//  Created by Don Garrett on 11/17/09.
//  Copyright 2009 Don Garrett. All rights reserved.
//

#import "OverheadRssManager.h"


@implementation OverheadRssManager

@synthesize delegate;


- (id)init {
    [super init];

    // Create an empty result set for now
	satellites = [[NSMutableArray alloc] init];

    return self;    
}


- (void)startRetrieving:(CLLocation *)currentLocation {
	
	NSString * url = [NSString stringWithFormat:@"http://orbitingfrog.com/overtwitter/rss.php?lat=%f&lng=%f",
                      currentLocation.coordinate.latitude,
                      currentLocation.coordinate.longitude];

    //  Local file for network disconnected development.
    //	NSString * url = @"file:///Users/dgarrett/tmp/test.rss";
    //url = @"file:///Users/dgarrett/tmp/test.rss";
    
	[self parseXMLFileAtURL:url];
}


- (void)parseXMLFileAtURL:(NSString *)URL {
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
	
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
	
	// Setup reasonable parsing options
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
}


-(void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");

    // Before parsing a new file, create a new (different) array to hold
    //   the results. Doing this insures that we don't confuse anyone reading
    //   the old values since we pass pointers to this array around.
	satellites = [[NSMutableArray alloc] init];
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Tell someone we errored out
    if (delegate)
        [delegate rssManager:self didFailWithError:parseError];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
	}
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
    // save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentSummary forKey:@"summary"];
		[item setObject:currentDate forKey:@"date"];
		
		[satellites addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);
	}
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {	
	NSLog(@"all done!");
	NSLog(@"satellites array has %d items", [satellites count]);
    
    // tell someone we finished
    if (delegate)
        [delegate rssManager:self didUpdate:satellites];    
}

@end
