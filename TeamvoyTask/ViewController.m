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
#import "TTPhoto.h"
#import "TTTableViewCell.h"
#import "TTLoadingTableViewCell.h"
#import "TTRandomPhotoViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<TTPhoto*> *currentPhotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) TTLoadingTableViewCell *loadCell;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) TTServerManager *manager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filter;



@end

@implementation ViewController

#pragma mark - Lazy

- (NSMutableArray<TTPhoto*>*) currentPhotos {
    if (!_currentPhotos) {
        _currentPhotos = [[NSMutableArray alloc] init];
    }
    return _currentPhotos;
}
/*
- (NSCache*) imageCache {
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
    }
    return _imageCache;
}
*/

#pragma mark - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
      
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self styleNavBar];
    
    TTServerManager *manager = [TTServerManager sharedManager];
    self.manager = manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [manager authorizeUser:^(TTUser *user) {
            NSLog(@"User authorized");
            
        }];
    });
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]) {
        NSString *filterApply = [self getCurrentFilterApply];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self getPhotosWithFilterApply:filterApply];
        });
        
    } else {
        NSLog(@"Coldn't fount Access Token");
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - UI methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) updateUI {
    
}

- (NSString*) getCurrentFilterApply {
    
    NSString *filterTypeLatest = @"latest";
    NSString *filterTypeOldest = @"oldest";
    NSString *filterTypePopulat = @"popular";
    
    NSString *filterType;
    
    if (self.filter.selectedSegmentIndex == 0) {
        filterType = filterTypeLatest;
    } else if (self.filter.selectedSegmentIndex == 1) {
        filterType = filterTypeOldest;
    } else if (self.filter.selectedSegmentIndex == 2) {
        filterType = filterTypePopulat;
    }
    return filterType;
}

- (void) getPhotosWithFilterApply:(NSString*)filter {
    __block NSMutableArray<TTPhoto*> *photosArray = [NSMutableArray array];
    [self.manager getPhotosFromServerWithPages:1
                         withItemsPerPage:10
                                orderedBy:filter
                    withCompletionHandler:^(NSMutableDictionary *dict) {
                        
                        
                        for (NSDictionary* photoDict in dict) {
                            TTPhoto *photo = [[TTPhoto alloc] initWithServerResponse:photoDict];
                            [photosArray addObject:photo];
                            
                        }
                        self.currentPhotos = photosArray;
                        // tableView reload
                        [self.tableView reloadData];
                        
                    }];
}

- (void)styleNavBar {

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    

    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    
    [newNavBar setBarStyle:UIBarStyleBlack];
    
    UINavigationItem *newItem = [[UINavigationItem alloc] init];
    newItem.title = @"Teamvoy Task";
    [newNavBar setItems:@[newItem]];
    
    /*BUTTON*/
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Random"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(pushRandomPhotoVC:)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Teamvoy Task"];
    item.rightBarButtonItem = rightButton;
    item.hidesBackButton = YES;
    [newNavBar pushNavigationItem:item animated:NO];
    
    
    [self.view addSubview:newNavBar];
}


#pragma mark - Actions

- (IBAction)setFilter:(UISegmentedControl *)sender {
    NSString *filterTypeLatest = @"latest";
    NSString *filterTypeOldest = @"oldest";
    NSString *filterTypePopulat = @"popular";
    
    if (sender.selectedSegmentIndex == 0) {
        [self getPhotosWithFilterApply:filterTypeLatest];
    } else if (sender.selectedSegmentIndex == 1) {
        [self getPhotosWithFilterApply:filterTypeOldest];
    } else if (sender.selectedSegmentIndex == 2) {
        [self getPhotosWithFilterApply:filterTypePopulat];
    }



}

- (void) pushRandomPhotoVC:(UIBarButtonItem*)item {
    TTRandomPhotoViewController *viewController = [[TTRandomPhotoViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}


- (IBAction)likeAction:(UIButton*)sender {
    
    TTPhoto *targetPhoto = [self.currentPhotos objectAtIndex:sender.tag];

    [self.manager likePhoto:targetPhoto
             withCompletion:^(NSDictionary *photoLikeDict) {
                 NSLog(@"Photo liked with ID: %@", [photoLikeDict valueForKey:@"liked_by_user"]);
             }];
    // update UI
    if ([sender.currentTitle isEqualToString:@"Like"]) {
        [sender setTitle:@"Unlike" forState:UIControlStateNormal];
    } else if ([sender.currentTitle isEqualToString:@"Unlike"]) {
        [sender setTitle:@"Like" forState:UIControlStateNormal];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.currentPhotos.count + 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.currentPhotos count]) {
        
        TTLoadingTableViewCell *loadCell;//  = [tableView dequeueReusableCellWithIdentifier:@"loadCell"];
        if (!loadCell) {
            [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TTLoadingTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"loadCell"];
            loadCell = [tableView dequeueReusableCellWithIdentifier:@"loadCell" forIndexPath:indexPath];
            self.loadCell = loadCell;
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[loadCell.contentView viewWithTag:100];
            [activityIndicator startAnimating];
        }
        
        return loadCell;
        
    } else {
    
        TTTableViewCell *cell;
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"TTTableViewCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        }
        
        TTPhoto *tmpPhoto = [self.currentPhotos objectAtIndex:indexPath.row];
        
        cell.cellPhotoID = tmpPhoto.photoID;
        cell.photoOwnerLabel.text = tmpPhoto.owner.name;
        cell.totalLikes.text = [NSString stringWithFormat:@"Total likes: %ld",(long)tmpPhoto.amountOfLikes];
        cell.photo.image = tmpPhoto.image;
        cell.photoOwnerImage.image = tmpPhoto.owner.image;
        [cell.likeButton addTarget:self
                            action:@selector(likeAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        cell.likeButton.tag = indexPath.row;
        if (tmpPhoto.liked == YES) {
            [cell.likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
        } else if (tmpPhoto.liked == NO){
            [cell.likeButton setTitle:@"Like" forState:UIControlStateNormal];
        }


        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.currentPhotos count]) {
        self.loadCell.indicator.hidden = NO;
        [self.loadCell.indicator startAnimating];
    }
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Height depending on photo size that comes from server
    // Fit cell size depending on Photo size (or inverse?)
    if (indexPath.row == [self.currentPhotos count]) {
        return 80;
    } else {
        return 375;
    }
}



@end
