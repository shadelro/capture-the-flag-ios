//
//  DetailViewController.h
//  capture_the_flag
//
//  Created by Shadel,Brent on 11/19/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Game;
@class Player;
@class CTFClient;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, CLLocationManagerDelegate>
{
    NSMutableData *responseData;
    CLLocationManager *locationManager;
    CTFClient *ctfClient;
}

@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) Player *player;

@property (weak, nonatomic) IBOutlet UILabel *flagXLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagYLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagHeldByLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalXLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalYLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamePlayerListLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameIsActiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerXLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerYLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerFlagLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerGameListLabel;

@property (weak, nonatomic) IBOutlet UIButton *addPlayer;
@property (weak, nonatomic) IBOutlet UIButton *tagPlayer;
@property (weak, nonatomic) IBOutlet UIButton *pickUpFlag;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;


@end
