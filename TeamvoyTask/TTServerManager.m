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

@property (weak, nonatomic) TTAccessToken *accessToken;
@property (strong, nonatomic) AFHTTPSessionManager *requestManager;


/** URL Session **/
@property (strong, nonatomic) NSString *requestReply;


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
    
    NSString *strWithAuthURL = @"https://unsplash.com/oauth/authorize";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def",@"client_id",
                            @"https://TeamvoyTask/auth/unsplash/callback", @"redirect_uri",
                            @"code", @"response_type"
                            , @"read_user", @"scope", nil];

    
    [self requestToURL:strWithAuthURL withMethodName:@"GET" andParams:params];
    
}

//** Make request to specific URL; **//
//** Useed HTTP Methods like (GET, POST)
//** If you don't need to pass params --> set "params" value to nil
// GET RESPONSE DATA
- (void) requestToURL:(NSString*)url withMethodName:(NSString*)methodName andParams:(NSDictionary*)params {
    
    //NSURLComponents *components = [NSURLComponents componentsWithString:params];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:methodName];
    for (NSString *key in params) {
        if (!key) {
            break;
        } else {
            [request setValue:[params valueForKey:key] forHTTPHeaderField:key];
        }
    }

    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                if ([response isKindOfClass:[NSDictionary class]]) {
                                                    
                                                    NSError *parseError = nil;
                                                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                    NSLog(@"RESPONSE DICTIONARY: %@", responseDictionary);
                                                    
                                                } else if([response isKindOfClass:[NSString class]]) {
                                                    NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                                    self.requestReply = requestReply;
                                                    NSLog(@"requestReply: %@", requestReply);
                                                }

                                            }];
    
    [task resume];

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
