//
//  TTLoginViewController.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTLoginViewController.h"


@interface TTLoginViewController ()

@property (copy, nonatomic) TTLoginCompletionBlock completionBlock;

@end

@implementation TTLoginViewController

- (id)initWithCompletionBlock:(TTLoginCompletionBlock)completionBlock
{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

@end
