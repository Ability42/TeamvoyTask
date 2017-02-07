//
//  TTUser.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString* portfolioImageURL;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* name;
 
- (id)initWithServerResponse:(NSDictionary *)response;

@end
