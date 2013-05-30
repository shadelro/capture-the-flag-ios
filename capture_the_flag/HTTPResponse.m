//
//  HTTPResponse.m
//  capture_the_flag
//
//  Created by Shadel,Brent on 12/20/12.
//  Copyright (c) 2012 Shadel,Brent. All rights reserved.
//

#import "HTTPResponse.h"

@implementation HTTPResponse

-(id)init:(NSDictionary *)newBody statusCode:(int)newStatusCode
{
    self.body = newBody;
    self.statusCode = newStatusCode;
    
    return self;
}

@end
