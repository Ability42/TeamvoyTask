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
    
    TTServerManager *manager = [TTServerManager sharedManager];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [manager authorizeUser:^(TTUser *user) {
            NSLog(@"User authorized");
            
        }];
    });
    /*
    [manager getPhotosFromServerWithPages:1
                         withItemsPerPage:2
                                orderedBy:@"oldest"
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        NSLog(@"Test CompletionHandler");
                    }];
    */
     
    /*
    [manager getPhotoWithID:@"gkT4FfgHO5o"
          completionHandler:^(NSMutableDictionary *dict) {
              NSLog(@"getPhotoWithID: %@", dict);
          }];
    */
    
    [manager likePhotoWithID:@"yC-Yzbqy7PY" withCompletion:^(NSMutableDictionary *dict) {
        NSLog(@"likePhotoWithID: %@", dict);
    }];

    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


@end
