//
//  TTPhoto.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/4/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTPhoto.h"
#import "TTUser.h"

@implementation TTPhoto

- (instancetype)initWithServerResponse:(NSDictionary *)response {
    self = [super init];
    if (self) {
        for (NSDictionary* photoDict in response) {
            NSLog(@"Photo dict: %@", photoDict);
            
            self.photoID = [photoDict objectForKey:@"id"];
            self.liked = [photoDict objectForKey:@"liked_by_user"];
            self.amountOfLikes = [[photoDict objectForKey:@"likes"] integerValue];
            
            // photo URL link
            NSDictionary* urlsDict = [photoDict objectForKey:@"urls"];
            self.photoURL = [urlsDict objectForKey:@"regular"];
            
            // photo owner (object)
            NSDictionary* userDict = [photoDict objectForKey:@"user"];
            self.owner = [[TTUser alloc] initWithServerResponse:userDict];
            // upload date
            
            
        }
    }
    return self;
}


- (NSString *)description {
    // test photos properties
    return [NSString stringWithFormat:@""];
}
@end
