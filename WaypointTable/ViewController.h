//
//  ViewController.h
//  WaypointTable
//
//  Created by Cory Siebler on 3/30/15.
//  Copyright (c) 2015 Cory Siebler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaypointLibrary.h"

@interface ViewController : UIViewController

@property (nonatomic, assign) NSInteger waypointIndex;
@property (strong, nonatomic) WaypointLibrary *waypoints;

@end

