//
//  TTServerManager.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTServerManager.h"
#import <AFNetworking/AFNetworking.h>

@interface TTServerManager ()

@property (strong, nonatomic) TTAccessToken *accessToken;
@property (strong, nonatomic) AFHTTPSessionManager *requestManager;

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
    /*
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *mainVC = window.rootViewController;
    
    
    [mainVC presentViewController:navController animated:YES completion:nil];
    
    */
    
    
    /*** Prepare Private Requests ***/

    /*
    NSString *strWithAuthURL = @"https://unsplash.com/oauth/authorize";
    NSDictionary *dictWithAuthParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"a261fa69cad0d4b9a1cc9a39e1a9cd27684cebce34d65a5201e205d16cd2ff55",@"client_id",
                                        @"teamvoytask://",@"redirect_url",
                                        @"fcc4fc2e317d99e41581d0a20c4208030ea4b118963b3ee80bea202baada4918",@"response_type",
                                        @"read_user", @"scope",
                                        nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:strWithAuthURL
      parameters:dictWithAuthParams
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *responseDict = (NSDictionary*)responseObject;
             NSLog(@"SUCCES: %@", responseDict);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"FAILURE: %@", error.localizedDescription);
         }];
    
    */
    
    /*** For public access ***/
    
    /*
    NSString *strWithPublicURL = @"https://api.unsplash.com/photos/?client_id=750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def";
    
    [manager GET:strWithPublicURL
      parameters:nil
        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    */
    
}


- (void) getPhotosFromServerWithOffset:(NSInteger)offset
                                count:(NSInteger)count
                             onSucces:(void (^)(NSArray *))success
                            onFailure:(void (^)(NSError *))failure {
    

    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //NSDictionary *params
    //NSString *urlString

    
}

@end
