//
//  TTServerManager.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTLoginViewController.h"
#import "TTUser.h"
#import "TTAccessToken.h"

@interface TTServerManager : NSObject

@property (nonatomic, strong, readonly) TTUser *currentUser;
@property (nonatomic, strong) TTAccessToken *accesToken;

+ (TTServerManager*) sharedManager;

- (void) authorizeUser:(void(^)(TTUser* user)) completion;
- (void) requestToURL:(NSString*)url withMethodName:(NSString*)methodName andParams:(NSDictionary*)params;
- (void) getPhotosFromServerWithOffset:(NSInteger)offset
                                count:(NSInteger)count
                             onSucces:(void (^)(NSArray *))success
                            onFailure:(void (^)(NSError *))failure;

@end
