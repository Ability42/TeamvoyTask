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
        NSLog(@"Photo dict: %@", response);
        
        self.photoID = [response objectForKey:@"id"];
        if ([[response valueForKey:@"liked_by_user"]  isEqual: @NO]) {
            self.liked = NO;
        } else {
            self.liked = YES;
        }
        
        self.amountOfLikes = [[response objectForKey:@"likes"] integerValue];
        
        // photo URL link
        NSDictionary* urlsDict = [response objectForKey:@"urls"];
        self.photoURLString = [urlsDict objectForKey:@"regular"];
        
        // photo owner (object)
        NSDictionary* userDict = [response objectForKey:@"user"];
        self.owner = [[TTUser alloc] initWithServerResponse:userDict];
        
        // непосрєдствіно фото
        NSURLSessionTask *photoDownloadTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:_photoURLString]
                                                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                              if (data) {
                                                                                  self.image = [UIImage imageWithData:data];
                                                                              }
                                                                              
                                                                          }];
        [photoDownloadTask resume];
        
    }
    return self;
}


- (NSString *)description {
    // test photos properties
    return [NSString stringWithFormat:@""];
}
@end
