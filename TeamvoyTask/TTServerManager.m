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

@property (weak, nonatomic) TTAccessToken *accessToken;
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
/*
- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [[NSURL alloc] initWithString:@"https://api.unsplash.com/"];
        self.requestManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}
*/

#pragma mark - API

- (void) authorizeUser:(void(^)(TTUser* user)) completion {
    
    TTLoginViewController *loginVC = [[TTLoginViewController alloc] initWithCompletionBlock:^(TTAccessToken *token) {
        self.accesToken = token;
        
        if (completion) {
            completion(nil);
        }
    }];
    
    UINavigationController *navController =  [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIViewController *mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:navController
                         animated:YES
                       completion:nil];
    
    
    
    static NSString *requesMethod = @"GET";
    
    /**** Create distinct session manager for manage request ****/
    // AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    /**** HTTP_DATA ****/
    NSString *urlString = [NSString stringWithFormat:@"https://unsplash.com/oauth/authorize?"];
    // NSString *urlString = @"https://unsplash.com/oauth/authorize/";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def",@"client_id",
                            @"https://TeamvoyTask/auth/unsplash/callback", @"redirect_uri",
                            @"code", @"response_type", @"read_user",
                            @"scope", nil];
    
    /**** AFNetworkin uses ****/

    /**** Redirection block (get callback code --> catch url request with accessToken)****/
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    /*
    [sessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        // This will be called if the URL redirects
        NSLog(@"%@", request.URL);
        return request;
    }];
    */
    /*
    [sessionManager GET:urlString
             parameters:params
               progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *dict = (NSDictionary*)responseObject;
                   NSLog(@"Response: %@", dict);
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"Error: %@", error);
               }];
    
    */
    
}

#pragma mark - NSURLSessionDelegate



@end
