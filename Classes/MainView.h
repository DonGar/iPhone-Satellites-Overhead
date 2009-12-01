//
//  MainView.h
//  OverHead
//
//  Created by Don Garrett on 11/10/09.
//  Copyright Don Garrett 2009. All rights reserved.
//

#import "MainViewController.h"
#import <UIKit/UIKit.h>

@interface MainView : UIView <UITableViewDataSource,UITableViewDelegate> {
    
    MainViewController *controller;
    
	UILabel *latLable;
	UILabel *longLable;
    
    UITableView *satTable;
}

- (void)refreshView;

@property (retain) MainViewController *controller;

@property (retain) IBOutlet UILabel *latLable;
@property (retain) IBOutlet UILabel *longLable;
@property (retain) IBOutlet UITableView *satTable;

@end
