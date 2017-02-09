//
//  TTRandomPhotoViewController.m
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import "TTRandomPhotoViewController.h"
#import "TTServerManager.h"
#import "TTPhoto.h"

@interface TTRandomPhotoViewController ()

@property (nonatomic, strong) TTPhoto* currentRandomPhoto;
@property (nonatomic, assign) NSInteger tmpLikes;

@end

@implementation TTRandomPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self styleNavBar];
    
    [[TTServerManager sharedManager] getRandomPhotoWithCompletionHandler:^(NSMutableDictionary *dict) {
        TTPhoto *photoObj = [[TTPhoto alloc]  initWithServerResponse:dict];
        self.portfolioPhoto.image = photoObj.owner.image;
        self.userName.text = photoObj.owner.name;

            self.photoID = photoObj.photoID;
        self.likes.text = [NSString stringWithFormat:@"Likes: %ld", photoObj.amountOfLikes];
        self.tmpLikes = photoObj.amountOfLikes;
        [self.likeButton addTarget:self
                            action:@selector(likeAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        self.currentRandomPhoto = photoObj;
        
        NSURLSessionTask *photoDownloadTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:photoObj.photoURLString]
                                                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                              
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  if (data) {
                                                                                      self.photo.image = [UIImage imageWithData:data];
                                                                                  }
                                                                              });
                                                                          }];
        [photoDownloadTask resume];
        
        NSURLSessionTask *portfolioPhotoDownloadTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:photoObj.owner.portfolioImageURL]
                                                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                              
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  if (data) {
                                                                                      self.portfolioPhoto.image = [UIImage imageWithData:data];
                                                                                  }
                                                                              });
                                                                          }];
        [portfolioPhotoDownloadTask resume];

    }];
    
    
}

#pragma mark - Action

- (void) downloadImage {
    
}

- (IBAction)likeAction:(UIButton*)sender {
    
    
    [[TTServerManager sharedManager] likePhoto:self.currentRandomPhoto withCompletion:^(NSDictionary *photoLikeDict) {
        NSLog(@"Photo liked: %@", self.currentRandomPhoto.photoID);
    }];
    
    if ([sender.titleLabel.text isEqualToString:@"Like"]) {
         [sender setTitle:@"Unlike" forState:UIControlStateNormal];
        self.tmpLikes++;
        self.likes.text = [NSString stringWithFormat:@"Likes %ld", self.tmpLikes];
    } else if ([sender.currentTitle isEqualToString:@"Unlike"]) {
         [sender setTitle:@"Like" forState:UIControlStateNormal];
        self.tmpLikes--;
        self.likes.text = [NSString stringWithFormat:@"Likes %ld", self.tmpLikes
                           ];
    }
    
}

- (void)styleNavBar {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    
    
    UINavigationItem *newItem = [[UINavigationItem alloc] init];
    newItem.title = @"Teamvoy Task";
    [newNavBar setItems:@[newItem]];
    
    /*BUTTON*/
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleDone target:self action:@selector(backToFeed:)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Random photo"];
    item.rightBarButtonItem = leftButton;
    item.hidesBackButton = YES;
    [newNavBar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:newNavBar];
}

- (void) backToFeed:(UIBarButtonItem*)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*:
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
