//
//  Game.h
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/17/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTFClient;

@interface Game : NSObject
{
    CTFClient *ctfClient;
}

@property (strong, nonatomic) NSString *gameName;
@property (strong, nonatomic) NSString *flagHeldBy;
@property (strong, nonatomic) NSMutableArray *playerList;
@property float flagX;
@property float flagY;
@property float goalX;
@property float goalY;
@property bool isActive;

-(id)init:(NSString *)newGameName withPlayers:(NSMutableArray *)newPlayerList goalX:(float)goalX goalY:(float)goalY defaultX:(float)defaultX defaultY:(float)defaultY;
-(id)load:(NSString *)gameToLoad;

@end
