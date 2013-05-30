//
//  CTFClient.h
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/20/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPResponse;

@interface CTFClient : NSObject
{
    NSMutableData *responseData;
}

-(HTTPResponse *)createPlayer:(NSString *)playerName;
-(HTTPResponse *)getPlayer:(NSString *)playerName;
-(HTTPResponse *)updatePlayer:(int)playerID withX:(float)x andY:(float)y;
-(HTTPResponse *)tagNearestPlayer:(NSString *)playerName gameName:(NSString *)gameName;
-(HTTPResponse *)pickUpFlag:(NSString *)gameName byPlayer:(int)playerID;

-(HTTPResponse *)createGame:(NSString *)gameName goalX:(float)goalX goalY:(float)goalY defaultX:(float)defaultX defaultY:(float)defaultY;
-(HTTPResponse *)getGameByName:(NSString *)gameName;
-(HTTPResponse *)addPlayer:(NSString *)playerName toGame:(NSString *)gameName;

@end
