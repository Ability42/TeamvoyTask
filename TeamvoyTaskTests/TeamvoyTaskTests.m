//
//  TeamvoyTaskTests.m
//  TeamvoyTaskTests
//
//  Created by Stepan Paholyk on 1/31/17.
//  Copyright © 2017 Stepan Paholyk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTServerManager.h"

@interface TeamvoyTaskTests : XCTestCase

@end

@implementation TeamvoyTaskTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    TTServerManager *manager = [TTServerManager sharedManager];
    //[manager authorizeUser:nil];
    
    NSString *strWithAuthURL = @"https://unsplash.com/oauth/authorize";
    
    NSString *urlString = [NSString stringWithFormat:@"https://unsplash.com/oauth/authorize?"
                           "client_id=750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def"
                           "&redirect_uri=https://TeamvoyTask/auth/unsplash/callback"
                           "&response_type=code"
                           "&scope=read_user"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"750e67cc319b423955139594aa10fad75123b7ddcea0fc337a84856dca367def",@"client_id",
                            @"https://TeamvoyTask/auth/unsplash/callback", @"redirect_uri",
                            @"code", @"response_type", @"read_user",
                            @"scope", nil];
    
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
