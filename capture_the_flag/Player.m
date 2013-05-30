//
//  Player.m
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/17/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import "HTTPResponse.h"
#import "Player.h"
#import "CTFClient.h"


@implementation Player

@synthesize playerName, xPos, yPos, hasFlag, gameList, flagList;

-(id)init:(NSString *)newPlayerName
{
    ctfClient = [[CTFClient alloc] init];
    
    [ctfClient createPlayer:newPlayerName];
    
    self.playerName = newPlayerName;
    self.xPos = 0;
    self.yPos = 0;
    self.flagList = [[NSMutableArray alloc] init];
    
    return self;
}


-(id)load:(NSString *)playerToLoad error:(NSError **)error;
{
    ctfClient = [[CTFClient alloc] init];

    HTTPResponse *response = [ctfClient getPlayer:playerToLoad];
    NSDictionary *responseJSON = response.body;
    if (response.statusCode == 200)
    {
        self.playerID = [[responseJSON objectForKey:@"id"] integerValue];
        self.playerName = [NSMutableString stringWithString:[responseJSON objectForKey:@"name"]];
        self.xPos = [[responseJSON objectForKey:@"latitude"] floatValue];
        self.yPos = [[responseJSON objectForKey:@"longitude"] floatValue];
        self.flagList = [NSMutableArray arrayWithArray:[responseJSON objectForKey:@"flags"]];
        self.gameList = [NSMutableArray arrayWithArray:[responseJSON objectForKey:@"games"]];
    
        return self;
    }

    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:[[NSString alloc] initWithFormat:@"received HttpResponse %d", response.statusCode] forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:@"load player" code:response.statusCode userInfo:details];
    return nil;
}


@end
