//
//  TTLoginViewController.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "TTServerManager.h"

@class TTAccessToken;

typedef void(^TTLoginCompletionBlock)(TTAccessToken* token);

@interface TTLoginViewController : ViewController

- (id) initWithCompletionBlock:(TTLoginCompletionBlock) completionBlock;

@end
