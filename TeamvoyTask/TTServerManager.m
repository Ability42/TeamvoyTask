//
//  TTServerManager.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTServerManager.h"
#import <AFNetworking/AFNetworking.h>

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

- (void) authorizeUser:(void(^)(TTUser* user)) compleion {
    /*
    TTLoginViewController *vc = [[TTLoginViewController alloc] initWithCompletionBlock:^(TTAccessToken *token) {
        self.accesToken = token;
        
        if (compleion) {
            compleion(nil);
        }
    }];
     */
    /*** Prepare Requests ***/
    //Authorization: Client-ID YOUR_APPLICATION_ID
    
    /*** requests methods ***/
    
    NSString *strWithAuthURL = @"https://unsplash.com/oauth/authorize";
    NSDictionary *dictWithAuthParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def",@"client_id",
                                        @"https://com.SP.TeamvoyTask/auth/unsplash/callback",@"redirect_uri",
                                        @"response_type", @"code",
                                        @"scope", @"public+read_user",nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /*** for private access ***/
    
    [manager GET:strWithAuthURL
       parameters:dictWithAuthParams
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *responseDict = (NSDictionary*)responseObject;
              NSLog(@"RESPONSE: %@", responseDict);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"ERROR: %@", error.localizedDescription);
          }];
    
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

- (void)getPhotosFromServerWithOffset:(NSInteger)offset
                                count:(NSInteger)count
                             onSucces:(void (^)(NSArray *))success
                            onFailure:(void (^)(NSError *))failure {
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //NSDictionary *params
    //NSString *urlString

    
}

@end
