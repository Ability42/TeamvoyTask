//
//  TTLoginViewController.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/1/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTAccessToken;

typedef void(^TTLoginCompletionBlock)(TTAccessToken* token);

@interface TTLoginViewController : UIViewController

- (id)initWithCompletionBlock:(TTLoginCompletionBlock) completionBlock;

@end
