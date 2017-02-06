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

static NSString* const kPhotosOrderDefault = @"latest";
static NSString* const kPhotosOrderPopular = @"popular";
static NSString* const kPhotosOrderOldest = @"oldest";


@interface TTServerManager : NSObject

@property (nonatomic, strong, readonly) TTUser *currentUser;
@property (nonatomic, strong) TTAccessToken *accesToken;
@property (strong, nonatomic) NSMutableURLRequest *unsplashRequest;

+ (TTServerManager*) sharedManager;

- (void) authorizeUser:(void(^)(TTUser* user)) completion;

- (void) getPhotosFromServerWithPages:(NSUInteger)page
                     withItemsPerPage:(NSUInteger)perPage
                            orderedBy:(NSString*)photosOrder
                withCompletionHandler:(void (^)(NSMutableDictionary* dict))completionHandle;

- (void) getPhotoWithID:(NSString*)photoID
      completionHandler:(void (^)(NSMutableDictionary* dict))completionHandler;

- (void) likePhotoWithID:(NSString*)photoID withCompletion:(void (^)(NSMutableDictionary* dict))completionHandler;
- (void) unlikePhotoAtURL:(NSString*)photoID;




@end
