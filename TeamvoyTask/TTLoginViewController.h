//
//  TTLoginViewController.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTAccessToken;

typedef void(^TTLoginCompletionBlock)(TTAccessToken* token);

@interface TTLoginViewController : NSObject

- (id) initWithCompletionBlock:(TTLoginCompletionBlock) completionBlock;

@end
