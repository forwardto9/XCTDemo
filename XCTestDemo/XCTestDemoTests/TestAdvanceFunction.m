//
//  TestAdvanceFunction.m
//  XCTestDemo
//
//  Created by uwei on 9/21/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestAdvanceFunction : XCTestCase

@end

@implementation TestAdvanceFunction

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)testM1 {
    NSLog(@"TestM1");
    
    int n = 10 * rand() / (RAND_MAX + 1) + 1;
    
    XCTAssertTrue((n < 0), @"Test message!");
}

- (void)testM2 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
