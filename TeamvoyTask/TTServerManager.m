//
//  TTServerManager.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTServerManager.h"
#import "TTPhoto.h"

@interface TTServerManager () <NSURLSessionDelegate>

@property (strong, nonatomic) TTAccessToken *accessToken;
@property (strong, nonatomic) NSDictionary *userJson;
@property (strong, nonatomic) TTUser *currentUser;

@property (strong, nonatomic) NSMutableArray *photosURL;

/** getPhotosFromServerWithPages **/
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;


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

/*** if user already authorized in previous session ***/
/*** getCurrent user will be called ***/
- (void) authorizeUser:(void(^)(TTUser* user)) completion {
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]) {
        [self getCurrentUser];
        
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

- (TTUser*) getCurrentUser {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://api.unsplash.com/me"];
    
    NSURL *url = components.URL;
    
    /***IMPORTANT: Pass bearer token ***/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [request setValue:[@"Bearer " stringByAppendingString:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block NSDictionary *jsonData = nil;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:nil];
                                                
                                    
                                            }];
    [task resume];
    [task currentRequest];

    TTUser *currentUser = [[TTUser alloc] initWithServerResponse:jsonData];
    return currentUser;
    
}

- (void) getPhotosFromServerWithPages:(NSUInteger)page
                     withItemsPerPage:(NSUInteger)perPage
                            orderedBy:(NSString*)photosOrder
                withCompletionHandler:(void (^)(NSMutableDictionary* dict))completionHandler {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://api.unsplash.com/photos"];
    
    NSURLQueryItem *pageItem = [NSURLQueryItem queryItemWithName:@"page" value:[NSString stringWithFormat:@"%ld", page]];
    NSURLQueryItem *perPageItem = [NSURLQueryItem queryItemWithName:@"per_page" value:[NSString stringWithFormat:@"%ld", perPage]];
    NSURLQueryItem *photosOrderItem = [NSURLQueryItem queryItemWithName:@"order_by" value:photosOrder];
    
    components.queryItems = @[pageItem,perPageItem,photosOrderItem];
    NSURL *url = components.URL;

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[@"Bearer " stringByAppendingString:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block NSMutableDictionary *jsonData;
//    __block NSMutableArray *photosURLArray = [NSMutableArray array];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                
                                                
                                                jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:nil];
                                                
                                                NSLog(@"JSON DATA: %@", jsonData);
                                                NSLog(@"JSON DATA: %@", [jsonData valueForKey:@"id"]);

                                                
                                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                    completionHandler(jsonData);
                                                }];
                                                
                                    
                                            }];
    
    [task resume];

}

- (NSDictionary*) getPhotoWithID:(NSString*)photoID completionHandler:(void (^)(NSMutableDictionary* dict))completionHandler {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://api.unsplash.com/photos"];
    
    NSURLQueryItem *photoIDItem = [NSURLQueryItem queryItemWithName:@"id" value:photoID];
    
    components.queryItems = @[photoIDItem];
    NSURL *url = components.URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[@"Bearer " stringByAppendingString:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block NSMutableDictionary *jsonData;
    NSURLSessionDataTask *getPhotoTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                        
                                                        NSLog(@"Response: %@", response);
                                                        
                                                        
                                                        jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                   options:0
                                                                                                     error:nil];
                                                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                            completionHandler(jsonData);
                                                        }];
                                                        
                                                    }];
    [getPhotoTask resume];
    return jsonData;
}

// this method performed for like/unlike photod
// if photo already liked --> unlike that photo
- (void) likePhotoWithID:(NSString*)photoID withCompletion:(void (^)(NSMutableDictionary* dict))completionHandler {
    
    /*
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://api.unsplash.com/photos"];
    
    NSURLQueryItem *photoIDItem = [NSURLQueryItem queryItemWithName:@"id" value:photoID];
    NSURLQueryItem *photoLikeItem = [NSURLQueryItem queryItemWithName:@"like" value:nil];

    components.queryItems = @[photoIDItem, photoLikeItem];
     */
    
    NSURL *url = [NSURL URLWithString:[[@"https://api.unsplash.com/photos/" stringByAppendingString:photoID] stringByAppendingString:@"/like"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[@"Bearer " stringByAppendingString:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    //if ([[[self getPhotoWithID:photoID
         //  completionHandler:nil] valueForKey:@"liked_by_user"]  isEqual: @NO]) {
      //  [request setHTTPMethod:@"DELETE"];
  //  } else {
        [request setHTTPMethod:@"POST"];
  //  }

    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block NSMutableDictionary *jsonData;
    NSURLSessionDataTask *postLike = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                                                        jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:0
                                                                                                    error:nil];

                                                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                            completionHandler(jsonData);
                                                        }];

                                                        
                                                    }];
    [postLike resume];

       
}

// Get a random photo
- (void) getRandomPhoto {
    
}





@end
