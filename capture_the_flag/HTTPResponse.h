//
//  HTTPResponse.h
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/20/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPResponse : NSObject

@property (strong, nonatomic) NSDictionary *body;
@property int statusCode;

-(id)init:(NSDictionary *)newBody statusCode:(int)newStatusCode;

@end
