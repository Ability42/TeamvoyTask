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
        self.photo.image = photoObj.image;
            self.photoID = photoObj.photoID;
        self.likes.text = [NSString stringWithFormat:@"Likes: %ld", photoObj.amountOfLikes];
        [self.likeButton addTarget:self
                            action:@selector(likeAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        self.currentRandomPhoto = photoObj;

    }];
    
    
}

#pragma mark - Action

- (IBAction)likeAction:(UIButton*)sender {
    
    
    [[TTServerManager sharedManager] likePhoto:self.currentRandomPhoto withCompletion:^(NSDictionary *photoLikeDict) {
        NSLog(@"Photo liked: %@", self.currentRandomPhoto.photoID);
    }];
    
    if ([sender.titleLabel.text isEqualToString:@"Like"]) {
        sender.titleLabel.text = @"Unlike";
        sender.titleLabel.tintColor = [UIColor grayColor];
    } else if ([sender.titleLabel.text isEqualToString:@"Unike"]) {
        sender.titleLabel.text = @"Like";
        sender.titleLabel.tintColor = [UIColor whiteColor];
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
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Title"];
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
