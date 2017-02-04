//
//  TTPhoto.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/4/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUser.h"

@interface TTPhoto : NSObject

@property (assign, nonatomic, getter=isLiked) BOOL liked; //byCurrent logged user
@property (strong, nonatomic) TTUser *owner;
@property (assign, nonatomic) NSUInteger amountOfLikes;

@end
