//
//  MasterViewController.h
//  capture_the_flag
//
//  Created by Shadel,Brent on 11/19/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTFClient;
@class DetailViewController;
@class Player;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) Player *player;

@end
