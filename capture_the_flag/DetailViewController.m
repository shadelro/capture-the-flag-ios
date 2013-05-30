//
//  DetailViewController.m
//  capture_the_flag
//
//  Created by Shadel,Brent on 11/19/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import "DetailViewController.h"
#import "HTTPResponse.h"
#import "JSON/JSON.h"
#import "Constants.h"
#import "CTFClient.h"
#import "Game.h"
#import "Player.h"


@implementation DetailViewController


#pragma mark - Managing the detail item

- (void)setGame:(id)newGame
{
    if (_game != newGame)
    {
        _game = newGame;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setPlayer:(id)newPlayer
{
    if (_player != newPlayer)
    {
        _player = newPlayer;
        
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.game) {
        self.gameLabel.text = self.game.gameName;
        
        NSString *playerListString = @"";
        NSString *delimiter;
        for (int i = 0; i < [self.game.playerList count]; i++)
        {
            playerListString = [playerListString stringByAppendingString:[self.game.playerList objectAtIndex:i]];
            delimiter = i < [self.game.playerList count]-1 ? @", " : @".";
            playerListString = [playerListString stringByAppendingString:delimiter];
        }
        self.gamePlayerListLabel.text = playerListString;
        self.gameIsActiveLabel.text = self.game.isActive ? @"Yes" : @"No";
        self.goalXLabel.text = [NSString stringWithFormat:@"%f", self.game.goalX];
        self.goalYLabel.text = [NSString stringWithFormat:@"%f", self.game.goalY];
        self.flagXLabel.text = [NSString stringWithFormat:@"%f", self.game.flagX];
        self.flagYLabel.text = [NSString stringWithFormat:@"%f", self.game.flagY];
        NSLog(@"held by: %@", self.game.flagHeldBy);
        self.flagHeldByLabel.text = self.game.flagHeldBy;
        
    }
    if (self.player)
    {
        self.playerLabel.text = self.player.playerName;
        
        self.playerXLabel.text = [NSString stringWithFormat:@"%09f", self.player.xPos];
        self.playerYLabel.text = [NSString stringWithFormat:@"%09f", self.player.yPos];
        NSString *delimiter;
        NSString *gameListString = @"";
        for (int i = 0; i < [self.player.gameList count]; i++)
        {
            gameListString = [gameListString stringByAppendingString:[self.player.gameList objectAtIndex:i]];
            delimiter = i < [self.player.gameList count]-1 ? @", " : @".";
            gameListString = [gameListString stringByAppendingString:delimiter];
        }
        self.playerGameListLabel.text = gameListString;
        if (self.game)
            self.playerFlagLabel.text = [self.player.flagList containsObject:self.game.gameName] ? @"Yes" : @"No";
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager startUpdatingLocation];
        
        ctfClient = [[CTFClient alloc] init];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (IBAction)addPlayerToGame:(id)sender
{
    HTTPResponse *response = [ctfClient addPlayer:@"Player2" toGame:self.game.gameName];
    if (response.statusCode == 200)
        [self.game.playerList addObject:@"Player2"];
    else
        NSLog(@"bad response: %d", response.statusCode);
    
    [self configureView];
}

- (IBAction)tagPlayer:(id)sender
{
    HTTPResponse *response = [ctfClient tagNearestPlayer:self.player.playerName gameName:self.game.gameName];
    if (response.statusCode != 200)
        NSLog(@"bad response: %d", response.statusCode);

    [self configureView];
}


- (IBAction)pickUpFlag:(id)sender
{
    if (![self.player.flagList containsObject:self.game.gameName])
    {
        HTTPResponse *response = [ctfClient pickUpFlag:self.game.gameName byPlayer:self.player.playerID];
        if (response.statusCode == 204)
        {
            [self.player.flagList addObject:self.game.gameName];
            self.game.flagX = self.player.xPos;
            self.game.flagY = self.player.yPos;
            self.game.flagHeldBy = [NSString stringWithFormat:@"%d", self.player.playerID];
            [self configureView];
        }
    }

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];

    if (self.player)
    {
        float newX = location.coordinate.latitude;
        float newY = location.coordinate.longitude;

        HTTPResponse *response = [ctfClient updatePlayer:self.player.playerID withX:newX andY:newY];
        if (response.statusCode == 200);
        {
            self.player.xPos = newX;
            self.player.yPos = newY;
            [self configureView];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // do some error handling
}



#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
