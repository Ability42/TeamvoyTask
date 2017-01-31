//
//  TTServerManager.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTUser.h"

@interface TTServerManager : NSObject

@property (nonatomic, strong, readonly) TTUser *currentUser;

+ (TTServerManager*) sharedManager;

- (void) authorizeUser:(void(^)(TTUser* user)) compleion;
- (void) getPhotosFromServerWithOffset:(NSInteger)offset
                                count:(NSInteger)count
                             onSucces:(void (^)(NSArray *))success
                            onFailure:(void (^)(NSError *))failure;

@end
