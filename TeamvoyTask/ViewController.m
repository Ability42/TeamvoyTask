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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray<TTPhoto*> *currentPhotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) TTLoadingTableViewCell *loadCell;
@property (strong, nonatomic) NSCache *imageCache;



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
    
      
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self styleNavBar];
    
    TTServerManager *manager = [TTServerManager sharedManager];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [manager authorizeUser:^(TTUser *user) {
            NSLog(@"User authorized");
            
        }];
    });
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]) {
        __block NSMutableArray<TTPhoto*> *photosArray = [NSMutableArray array];
        [manager getPhotosFromServerWithPages:1
                             withItemsPerPage:10
                                    orderedBy:@"popular"
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
    
/*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.currentPhotos = photosArray;
    });
*/
    
    /*
    [manager getPhotoWithID:@"gkT4FfgHO5o"
          completionHandler:^(NSMutableDictionary *dict) {
              NSLog(@"getPhotoWithID: %@", dict);
          }];
    */
    /*
    [manager likePhotoWithID:@"ABDTiLqDhJA" withCompletion:^(NSMutableDictionary *dict) {
        NSLog(@"likePhotoWithID: %@", dict);
    }];
    */


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - UI methods

- (void) updateUI {
    
}

- (void)styleNavBar {

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    

    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    
    [newNavBar setBarStyle:UIBarStyleBlack];
    
    UINavigationItem *newItem = [[UINavigationItem alloc] init];
    newItem.title = @"Teamvoy Task";
    [newNavBar setItems:@[newItem]];

    [self.view addSubview:newNavBar];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.currentPhotos.count + 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.currentPhotos count]) {
        
        TTLoadingTableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"loadCell"];
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
        
        cell.photoOwnerLabel.text = tmpPhoto.owner.name;
        cell.totalLikes.text = [NSString stringWithFormat:@"%ld",(long)tmpPhoto.amountOfLikes];
        cell.photo.image = tmpPhoto.image;
        cell.photoOwnerImage.image = tmpPhoto.owner.image;


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
