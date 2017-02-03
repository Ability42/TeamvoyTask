//
//  TTAccessToken.h
//  TeamvoyTask
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTAccessToken : NSObject

@property (strong, nonatomic) NSString* tokenCode;
@property (strong,nonatomic) NSString* tokenType;
@property (strong,nonatomic) NSString* refreshTokenCode;
@property (strong, nonatomic) NSString* scope;
@property (strong, nonatomic) NSDate* expirationDate;

@end
