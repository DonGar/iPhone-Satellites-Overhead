//
//  OverHeadAppDelegate.h
//  OverHead
//
//  Created by Don Garrett on 11/10/09.
//  Copyright Don Garrett 2009. All rights reserved.
//

@class MainViewController;

@interface OverHeadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;

@end

