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
#import "AFOAuth2Manager.h"

static NSString * const kUnsplashTokenURI = @"https://unsplash.com/oauth/token";
static NSString * const kClientID = @"50e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def";
static NSString * const kClientSecret = @"3f012ff391636399d07e5f7e101c4a8b4feeb4c68b5aebf1a60c48edad7804c5";


@interface TTLoginViewController () <UIWebViewDelegate, NSURLSessionTaskDelegate>


@property (copy, nonatomic) TTLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView *webView;
@property (strong, nonatomic) TTServerManager *serverManager;

@property (strong, nonatomic) NSMutableURLRequest *unsplashURLRequest;
@property (weak, nonatomic) IBOutlet UIWebView *unsplashWebAPIRequest;
@property (strong, nonatomic) NSString* callbackCode;


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
    self.unsplashWebAPIRequest = webView;
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(cancelAction:)];
    
    self.navigationItem.title = @"Login";
    [self.navigationItem setRightBarButtonItem:doneItem animated:NO];
    [self.navigationController.view addSubview:webView];
    [self.view addSubview:self.unsplashWebAPIRequest];
    

    [self displayAuthPage];
    
    
}

- (void) prepareWebViewForLogin {
    
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    //self.webView.delegate = nil;
}

#pragma mark - Auth methods

- (void) displayAuthPage {
    /*** Create request for auth code***/
    
    /**** HTTP_DATA ****/
    NSString *urlString = [NSString stringWithFormat:@"https://unsplash.com/oauth/authorize/"];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def",@"client_id",
                            @"https://TeamvoyTask/auth/unsplash/callback", @"redirect_uri",
                            @"code", @"response_type",
                            @"read_user", @"scope", nil];

    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    self.unsplashURLRequest = [serializer requestWithMethod:@"GET"
                                                  URLString:urlString
                                                 parameters:params
                                                      error:nil];

    
    [self.unsplashWebAPIRequest loadRequest:self.unsplashURLRequest
                                   progress:nil
                                    success:^NSString * _Nonnull(NSHTTPURLResponse * _Nonnull response, NSString * _Nonnull HTML) {
                                        NSLog(@"%@", response );
                                        NSLog(@"The response URL: %@ ", response.URL);
                                        
                                        return HTML;
                                    } failure:^(NSError * _Nonnull error) {
                                        NSLog(@"You may have gotten an error, but the URLRequest was: %@ ", self.unsplashURLRequest);
                                    }];
}

#pragma mark - Actions


- (void) cancelAction:(UIBarButtonItem*)sender {
    
    if(self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


- (void) getAccessToken {
    
    
    AFOAuth2Manager *tokenClientRequest = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:kUnsplashTokenURI]
                                                                          clientID:kClientID
                                                                            secret:kClientSecret];
    
    [tokenClientRequest authenticateUsingOAuthWithURLString:kUnsplashTokenURI
                                                       code:self.callbackCode
                                                redirectURI:[kUnsplashTokenURI lowercaseString]
                                                    success:^(AFOAuthCredential * _Nonnull credential) {
                                                        //the AFOAuth does the heavy lifting here, but it gets me a token
                                                        
                                                        NSLog(@" MY CREDENTIALS! %@", credential.accessToken);
                                                        if ([AFOAuthCredential storeCredential:credential withIdentifier:@"unsplash"]) {
                                                            NSLog(@"Credential stoder");
                                                            
                                                        }
                                                        //dismiss the modally presented view
                                                        [self dismissViewControllerAnimated:YES
                                                                                 completion:nil];
                                                        NSLog(@"ACCESSTOKEN: %@", [credential accessToken]);
                                                    } failure:^(NSError * _Nonnull error) {
                                                        NSLog(@"No credentials :(   \n and Error: %@", error);
                                                    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"Navigation type: %lu, The should request: %@", navigationType, request);
    /*
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"The Request URL: %@", request.URL);
        NSLog(@"The request headers: %@", request.allHTTPHeaderFields);
        NSLog(@"The http data: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSASCIIStringEncoding] );
    }
     */
    
    // TODO Separeted on methods
    NSLog(@"ABSOLUTE STR REQUEST: %@", [request.URL absoluteString]);
    if ([[request.URL absoluteString] containsString:@"callback?code="]) {
        NSArray *components = [[request.URL absoluteString] componentsSeparatedByString:@"callback?code="] ;
        NSLog(@"Callback code: %@", [components lastObject]);
        self.callbackCode = [components lastObject];
//        [webView stopLoading];
        [self getAccessToken];
        
    
        
        
        
    }
    
    
    
   // check if callback
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"ERROR LOAD WEB VIEW: %@", error.localizedDescription);
    if (error.code == -1003) {
        NSLog(@"ERROR CODE: %ld", error.code);
    }
}

#pragma mark - NSURLSessionTaskDelegate


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
     
     NSLog(@"NEW REQUEST: %@", request);
    
}







@end
