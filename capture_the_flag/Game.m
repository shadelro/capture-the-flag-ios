//
//  Game.m
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/17/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import "CTFClient.h"
#import "Game.h"
#import "HTTPResponse.h"
#import "Player.h"


@implementation Game


@synthesize gameName, playerList, isActive, flagX, flagY;

-(id)init:(NSString *)newGameName withPlayers:(NSMutableArray *)newPlayerList goalX:(float)goalX goalY:(float)goalY defaultX:(float)defaultX defaultY:(float)defaultY
{
    ctfClient = [[CTFClient alloc] init];
    
    [ctfClient createGame:newGameName goalX:goalX goalY:goalY defaultX:defaultX defaultY:defaultY];
    for (Player *player in newPlayerList)
        [ctfClient addPlayer:player.playerName toGame:newGameName];

    self.gameName = newGameName;
    self.goalX = goalX;
    self.goalY = goalY;
    self.playerList = newPlayerList;
    self.isActive = NO;
    self.flagHeldBy = @"";
    self.flagX = 0;
    self.flagY = 0;
    
    return self;
}

-(id)load:(NSString *)gameToLoad;
{
    ctfClient = [[CTFClient alloc] init];
    
    HTTPResponse *response = [ctfClient getGameByName:gameToLoad];
    NSDictionary *responseJSON = response.body;
    
    self.gameName = [NSMutableString stringWithString:[responseJSON objectForKey:@"name"]];
    self.goalX = [[responseJSON objectForKey:@"latitude_goal"] floatValue];
    self.goalY = [[responseJSON objectForKey:@"longitude_goal"] floatValue];
    self.playerList = [NSMutableArray arrayWithArray:[responseJSON objectForKey:@"users"]];
    self.isActive = [[responseJSON objectForKey:@"in_progress?"] boolValue];
    self.flagX = [[responseJSON objectForKey:@"flag_latitude"] floatValue];
    self.flagY = [[responseJSON objectForKey:@"flag_longitude"] floatValue];
    self.flagHeldBy = [NSMutableString stringWithString:[responseJSON objectForKey:@"flag_held_by"]];
    
    return self;
}

@end
