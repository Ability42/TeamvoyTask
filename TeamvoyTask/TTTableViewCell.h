//
//  TTTableViewCell.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 2/6/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoOwnerImage;
@property (weak, nonatomic) IBOutlet UILabel *photoOwnerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *totalLikes;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) NSString *cellPhotoID;

- (void) cellSetup;

@end
