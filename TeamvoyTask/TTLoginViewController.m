//
//  TTLoginViewController.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/1/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTLoginViewController.h"
#import "TTServerManager.h"

@interface TTLoginViewController () <UIWebViewDelegate, NSURLSessionDelegate>
@property (copy, nonatomic) TTLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView *webView;

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
    
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelAction:)];
    self.navigationItem.title = @"Test login";
    [self.navigationItem setRightBarButtonItem:doneItem];
    
    
    /*** Create request for auth code***/

    
    NSString *urlString = [NSString stringWithFormat:@"https://unsplash.com/oauth/authorize?"
                           "client_id=750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def"
                           "&redirect_uri=https://TeamvoyTask/auth/unsplash/callback"
                           "&response_type=code"
                           "&scope=read_user"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSURLRequest *request= [NSURLRequest requestWithURL:url];
    NSURLSession *mainSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDatatask = [mainSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                               
                                                           }];
    [sessionDatatask resume];

    
    
    
    
    
    
    
    [webView loadRequest:request];
    // if code succesfully retrieved --> exchange on token
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
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
    NSLog(@"%@", [request URL]);

    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
/*
    NSURL *redirectedURL = [webView.request mainDocumentURL];
    NSData *dataWithUrl = [[NSData alloc] initWithContentsOfURL:redirectedURL];
 
    NSString *stringWithURL = [[NSString alloc] initWithData:dataWithUrl
                                                    encoding:NSUTF32StringEncoding];
    NSLog(@"REDIRECTED URL:\t %@", stringWithURL);
*/
    
    NSURL *url = [webView.request mainDocumentURL];
    NSLog(@"The Redirected URL is: %@", url);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
    //NSLog(@"%@",[(NSHTTPURLResponse*)resp.response allHeaderFields]);
    
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{

    
}



#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    
}



@end
