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

- (void)loadView {
    [super loadView];
    
    TTServerManager *manager = [TTServerManager sharedManager];
    [manager authorizeUser:^(TTUser *user) {
        NSLog(@"Complete");
    }];
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:r];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelAction:)];
    self.navigationItem.title = @"Test login";
    [self.navigationItem setRightBarButtonItem:doneItem];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Actions

- (void) cancelAction:(UIBarButtonItem*)sender {
    
    if(self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
