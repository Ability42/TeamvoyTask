//
//  TTUser.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTUser.h"

@implementation TTUser

- (id)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        self.firstName = [response objectForKey:@"first_name"];
        self.lastName = [response objectForKey:@"last_name"];
        
    }
    return self;
}

@end
