//
//  XCTestDemoUITests.m
//  XCTestDemoUITests
//
//  Created by uwei on 9/21/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface XCTestDemoUITests : XCTestCase {
    @private
    ViewController *vc;
}
@end

@implementation XCTestDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)testEmptyNameAndPassword {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    // 1. 在identity inspector 中 Accessibility 面板中为控件添加identifier，然后在此处就可以使用这个identifier检索控件
    [app.buttons[@"userLogin"] tap];
    // 2. 使用button的title作为key检索button
    [app.buttons[@"Login"] tap];
    [app.alerts[@"Error"].buttons[@"OK"] tap];
    
}


/**
 测试完整的登录事件
 */
- (void)testLoginOK {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    // XCode检索控件的方法
//    XCUIElement *textField = [[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Login"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0];
    
    
    // 在identity inspector 中 Accessibility 面板中为控件添加identifier，然后在此处就可以使用这个identifier检索控件
    XCUIElement *textField = app.textFields[@"userName"];
    [textField tap];
    [textField typeText:@"Test"];
    
    // XCode检索控件的方法
    XCUIElement *textField1 = [[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Login"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:1];
    [textField1 tap];
    [textField1 typeText:@"pass"];
    

    [app.buttons[@"Login"] tap];
    [app.navigationBars[@"SigninView"].buttons[@"Login"] tap];
}


- (void)testSwitchAndCount {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *switch2 = app.switches[@"0"];
    [switch2 tap];
    
    XCUIElement *timeLabel = app.staticTexts[@"timesLabel"];
    NSString *count = timeLabel.label;
    XCTAssertTrue(count.integerValue > 0, @"count > 0");
    
    XCUIElement *switch3 = app.switches[@"1"];
    [switch3 tap];
    [switch2 tap];
    [switch3 tap];
    [switch2 tap];
    [app.navigationBars[@"SigninView"].buttons[@"Login"] tap];
    
}


@end
