//
//  TTRandomPhotoViewController.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/8/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTRandomPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *portfolioPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) NSString *photoID;

@end
