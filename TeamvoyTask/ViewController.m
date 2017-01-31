//
//  ViewController.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "ViewController.h"
#import "TTServerManager.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TTServerManager *manager = [TTServerManager sharedManager];
    [manager authorizeUser:^(TTUser *user) {
        NSLog(@"hello user");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


@end
