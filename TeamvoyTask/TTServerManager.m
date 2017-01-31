//
//  TTServerManager.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTServerManager.h"
#import "TTLoginViewController.h"
#import <AFNetworking/AFNetworking.h>

@implementation TTServerManager

#pragma mark - API

+ (TTServerManager*) sharedManager {
    
    static TTServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TTServerManager alloc] init];
    });
    
    return manager;
}

- (void) authorizeUser:(void(^)(TTUser* user)) compleion {
    
    
    
}

- (void)getPhotosFromServerWithOffset:(NSInteger)offset
                                count:(NSInteger)count
                             onSucces:(void (^)(NSArray *))success
                            onFailure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //NSDictionary *params
    //NSString *urlString

    
}

@end
