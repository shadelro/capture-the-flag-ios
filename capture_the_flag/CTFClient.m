//
//  CTFClient.m
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/20/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import "CTFClient.h"
#import "Constants.h"
#import "HTTPResponse.h"
#import "JSON/JSON.h"


@implementation CTFClient

-(id)init
{
    return self;
}

-(HTTPResponse *)createPlayer:(NSString *)playerName
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/users/create", ctfBaseURL];
    NSString *postString = [[NSString alloc] initWithFormat:@"player_name=%@", playerName];
    return [self post:url withPostData:postString];
}


-(HTTPResponse *)getPlayer:(NSString *)playerID
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/users/%@", ctfBaseURL, playerID];
    return [self get:url];
}


-(HTTPResponse *)updatePlayer:(int)playerID withX:(float)x andY:(float)y
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/users/%d/update_location", ctfBaseURL, playerID];
    NSString *postString = [[NSString alloc] initWithFormat:@"latitude=%09f&longitude=%09f", x, y];
    return [self post:url withPostData:postString];
}

-(HTTPResponse *)tagNearestPlayer:(NSString *)playerName gameName:(NSString *)gameName
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/users/%@/tag_nearest_player", ctfBaseURL, playerName];
    NSString *postString = [[NSString alloc] initWithFormat:@"game_name=%@", gameName];
    return [self post:url withPostData:postString];
}

-(HTTPResponse *)createGame:(NSString *)gameName goalX:(float)goalX goalY:(float)goalY defaultX:(float)defaultX defaultY:(float)defaultY
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/games/create_game", ctfBaseURL];
    NSString *postString = [[NSString alloc] initWithFormat:@"game_name=%@&goal_x=%f&goal_y=%f&default_x=%f&default_y=%f", gameName, goalX, goalY, defaultX, defaultY];
    return [self post:url withPostData:postString];
}


-(HTTPResponse *)getGameByName:(NSString *)gameName
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/games/%@", ctfBaseURL, gameName];
    return [self get:url];
}

-(HTTPResponse *)getGamesForUser:(NSString *)userID
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/games?user_id=%d", ctfBaseURL, 1];
    return [self get:url];
}


-(HTTPResponse *)addPlayer:(NSString *)playerName toGame:(NSString *)gameName
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/games/%@/add_player", ctfBaseURL, gameName];
    NSString *postData = [[NSString alloc] initWithFormat:@"player_name=%@", playerName];
    return [self post:url withPostData:postData];
}

-(HTTPResponse *)pickUpFlag:(NSString *)gameName byPlayer:(int)playerID
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@/users/%d/pick_up_flag", ctfBaseURL, playerID];
    NSString *postData = [[NSString alloc] initWithFormat:@"game_name=%@", gameName];
    return [self post:url withPostData:postData];
}


-(HTTPResponse *)get:(NSString *)urlString
{
    responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return [self sendRequest:request];
}


-(HTTPResponse *)post:(NSString *)urlString withPostData:(NSString *)postDataString
{
    responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *postData = [postDataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];

	return [self sendRequest:request];
}

-(HTTPResponse *)sendRequest:(NSMutableURLRequest *)request
{
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    SBJSON *json = [SBJSON new];
    NSMutableDictionary *responseDict = [json objectWithString:responseString];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    return [[HTTPResponse alloc] init:responseDict statusCode:[httpResponse statusCode]];;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}


@end
