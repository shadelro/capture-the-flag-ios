//
//  Player.h
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/17/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTFClient;

@interface Player : NSObject
{
    CTFClient *ctfClient;
}

@property int playerID;
@property (strong, nonatomic) NSString *playerName;
@property float xPos;
@property float yPos;
@property bool hasFlag;
@property (strong, nonatomic) NSMutableArray *gameList;
@property (strong, nonatomic) NSMutableArray *flagList;

-(id)init:(NSString *)newPlayerName;
-(id)load:(NSString *)playerName error:(NSError **)error;

@end
