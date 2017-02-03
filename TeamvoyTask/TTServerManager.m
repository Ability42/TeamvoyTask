//
//  TTServerManager.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTServerManager.h"
#import <AFNetworking/AFNetworking.h>

@interface TTServerManager () <NSURLSessionDelegate>

@property (strong, nonatomic) TTAccessToken *accessToken;
@property (strong, nonatomic) AFHTTPSessionManager *requestManager;

/** URL Session **/



@end

@implementation TTServerManager

#pragma mark - Init

+ (TTServerManager*) sharedManager {
    
    static TTServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TTServerManager alloc] init];
    });
    
    return manager;
}


#pragma mark - API

- (void) authorizeUser:(void(^)(TTUser* user)) completion {
    
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] initWithCompletionBlock:^(TTAccessToken *token) {
        self.accesToken = token;
        
        NSLog(@"%@", token.tokenCode);
    }];
    
    UINavigationController *navController =  [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIViewController *mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:navController
                         animated:YES
                       completion:nil];
    
    
}

- (void) getUser {
    
}











@end
