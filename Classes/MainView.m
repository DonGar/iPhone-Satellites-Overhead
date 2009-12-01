//
//  MainView.m
//  OverHead
//
//  Created by Don Garrett on 11/10/09.
//  Copyright Don Garrett 2009. All rights reserved.
//

#import "MainView.h"

@implementation MainView

@synthesize controller;
@synthesize latLable;
@synthesize longLable;
@synthesize satTable;


- (void)refreshView {
	if (controller.location == nil) {
		latLable.text = @"";
		longLable.text = @"";
		return;
	}
	
	latLable.text = [[NSNumber numberWithDouble:controller.location.coordinate.latitude] stringValue];
	longLable.text = [[NSNumber numberWithDouble:controller.location.coordinate.longitude] stringValue];
    
    [satTable reloadData];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // assert [indexPath indexAtPosition:0] == 0 since we only have one section.
    
    
    // Discover the satellite data we have
    NSMutableDictionary * item = [controller.satellites objectAtIndex:[indexPath indexAtPosition:1]];

    
	// Configure the cell.
    //   title
    //   summary
    cell.text = [item objectForKey:@"title"];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return controller.satellites.count;
}

#pragma mark UITableViewDelegate 
// None implemented


#pragma mark UIView

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
	}

    return self;
}


- (void)drawRect:(CGRect)rect {	
    // Drawing code
}


- (void)dealloc {
	latLable = nil;
	longLable = nil;
	
    [super dealloc];
}

@end
