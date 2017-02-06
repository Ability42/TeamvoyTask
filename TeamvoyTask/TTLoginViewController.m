//
//  TTLoginViewController.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/1/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "TTLoginViewController.h"
#import "TTServerManager.h"


static NSString * const kUnsplashTokenURI = @"https://unsplash.com/oauth/token";
static NSString * const kClientID = @"50e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def";
static NSString * const kClientSecret = @"3f012ff391636399d07e5f7e101c4a8b4feeb4c68b5aebf1a60c48edad7804c5";
static NSString * const kHostURL = @"teamvoytask";


@interface TTLoginViewController () <UIWebViewDelegate>


@property (copy, nonatomic) TTLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView *webView;
@property (strong, nonatomic) TTServerManager *serverManager;

@property (strong, nonatomic) NSString* callbackCode;
@property (strong, nonatomic) NSDictionary* tokenParams;



@end

@implementation TTLoginViewController


#pragma mark - Init

- (id)initWithCompletionBlock:(TTLoginCompletionBlock) completionBlock
{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

#pragma mark - VC lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:r];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(cancelAction:)];
    
    self.navigationItem.title = @"Login";
    [self.navigationItem setRightBarButtonItem:doneItem animated:NO];
    [self.navigationController.view addSubview:webView];
    [self.view addSubview:self.webView];
    
    
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self createAccessTokenObject];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] == nil) {
        NSURLComponents *components = [NSURLComponents componentsWithString:@"https://unsplash.com/oauth/authorize"];
        
        NSURLQueryItem *qItem1 = [NSURLQueryItem queryItemWithName:@"client_id"
                                                             value:@"750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def"];
        NSURLQueryItem *qItem2 = [NSURLQueryItem queryItemWithName:@"redirect_uri"
                                                             value:@"https://teamvoytask/auth/unsplash/callback"];
        NSURLQueryItem *qItem3 = [NSURLQueryItem queryItemWithName:@"response_type"
                                                             value:@"code"];
        NSURLQueryItem *qItem4 = [NSURLQueryItem queryItemWithName:@"scope"
                                                             value:@"public+read_user+write_likes+read_photos"];
        
        components.queryItems = @[qItem1, qItem2, qItem3, qItem4];
        NSURL *url = components.URL;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"GET"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
        [self.webView loadRequest:task.currentRequest];
    }
}

#pragma mark - Auth methods

- (void) getAccessToken {
    [self.webView stopLoading];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://unsplash.com/oauth/token"];
    
    NSURLQueryItem *qItem1 = [NSURLQueryItem queryItemWithName:@"client_id"
                                                         value:@"750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def"];
    NSURLQueryItem *qItem2 = [NSURLQueryItem queryItemWithName:@"client_secret"
                                                         value:@"3f012ff391636399d07e5f7e101c4a8b4feeb4c68b5aebf1a60c48edad7804c5"];
    NSURLQueryItem *qItem3 = [NSURLQueryItem queryItemWithName:@"redirect_uri"
                                                         value:@"https://teamvoytask/auth/unsplash/callback"];
    NSURLQueryItem *qItem4 = [NSURLQueryItem queryItemWithName:@"code"
                                                         value:self.callbackCode];
    NSURLQueryItem *qItem5 = [NSURLQueryItem queryItemWithName:@"grant_type"
                                                         value:@"authorization_code"];
    
    components.queryItems = @[qItem1, qItem2, qItem3, qItem4, qItem5];
    NSURL *requestedUrl = components.URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestedUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:nil];
                                                
                                                self.tokenParams = json;
                                                NSLog(@"Data: %@", json);
                                                if ([json objectForKey:@"access_token"]) {
                                                    [self dismissViewControllerAnimated:self completion:nil];
                                                }
                                            }];
    
    [task resume];
}
- (void) createAccessTokenObject {
    TTAccessToken *accessToken = [[TTAccessToken alloc] init];
    
    accessToken.tokenCode = [self.tokenParams objectForKey:@"access_token"];
    accessToken.refreshTokenCode = [self.tokenParams objectForKey:@"refresh_token"];
    
    /*** Pass Completion Block ***/
    if (self.completionBlock) {
        self.completionBlock(accessToken);
    }
    /*** Kill Web View ***/
    self.webView.delegate = nil;
    self.webView = nil;
    
    
    /*** Kill Controller ***/
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    /*** Save Bearer Token for further requests ***/
    NSUserDefaults *tokenDefaults = [NSUserDefaults standardUserDefaults];
    [tokenDefaults setObject:accessToken.tokenCode forKey:@"access_token"];
    

    
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) dealloc {
    self.webView.delegate = nil;
}

#pragma mark - Actions


- (void) cancelAction:(UIBarButtonItem*)sender {
    
    if(self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];

}





#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([[request.URL absoluteString] containsString:@"callback?code="]) {
        
        NSArray *components = [[request.URL absoluteString] componentsSeparatedByString:@"callback?code="] ;
        NSLog(@"Callback code: %@", [components lastObject]);
        self.callbackCode = [components lastObject];
        if (self.callbackCode) {
            /*** Now we can get accessToken ***/
            [self getAccessToken];
        }
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finished");
    NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
    NSLog(@"%@",[(NSHTTPURLResponse*)resp.response allHeaderFields]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"ERROR LOAD WEB VIEW: %@", error.userInfo);
}






@end
