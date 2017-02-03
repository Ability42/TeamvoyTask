//
//  ViewController.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "ViewController.h"
#import "TTServerManager.h"
#import "TTLoginViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // if !logig show Login view Controller
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[TTServerManager sharedManager] authorizeUser:^(TTUser *user) {
            NSLog(@"User authorized");
        }];
    });
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


@end
