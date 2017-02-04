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
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]) {
        
        NSURLComponents *components = [NSURLComponents componentsWithString:@"https://api.unsplash.com/me"];

        NSURL *url = components.URL;

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        [request setValue:[@"Bearer " stringByAppendingString:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
        
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:nil];
                                                    
                                                    
                                                    NSLog(@"Data: %@", json);
                                                }];
        [task resume];
        [task currentRequest];
        NSLog(@"task.currentRequest %@", task.currentRequest);
    } else {
        
        TTLoginViewController *loginVC = [[TTLoginViewController alloc] initWithCompletionBlock:^(TTAccessToken *token) {
            self.accessToken = token;
            
            NSLog(@"%@", token.tokenCode);
        }];
        
        UINavigationController *navController =  [[UINavigationController alloc] initWithRootViewController:loginVC];
        UIViewController *mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
        
        [mainVC presentViewController:navController
                             animated:YES
                           completion:nil];
    }
    
}

- (void) getUser {
    
}











@end
