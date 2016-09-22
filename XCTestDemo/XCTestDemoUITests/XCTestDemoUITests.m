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

// 启动测试的命令行, 关于destination的参数部分，都是使用key-value,每哥key pair之间不能有空格
// xcodebuild test -project XCTestDemo.xcodeproj -scheme XCTestDemo -destination 'platform=iOS Simulator,OS=10.0,name=iPhone 7 Plus'
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
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
//    [[XCUIApplication new] terminate];
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // type query provider
    XCUIElementQuery *buttonQuery = app.buttons;
    
    
    
    NSLog(@"button count : %ld", buttonQuery.count);
    
    XCUIElement *button1 = [buttonQuery elementBoundByIndex:0];
    
    [button1 tap];
    
    XCUIElement *button2 = [buttonQuery elementAtIndex:1];
    // TODO:how to use predicate
//    XCUIElement *button2 = [buttonQuery elementMatchingPredicate:[NSPredicate predicateWithFormat:@"self.tag == 100"]];
    [button2 tap];
    
    
    
    
    
    
    XCUIElementQuery *textFieldQuery = app.textFields;
    NSLog(@"textField count : %ld", textFieldQuery.count);
    
    XCUIElementQuery *typeQuery = [[[XCUIElementQuery alloc] init] childrenMatchingType:(XCUIElementTypeTextField)];
    XCUIElement *usernameTextField = [typeQuery elementBoundByIndex:0];
//    [usernameTextField tap];
    [usernameTextField typeText:@"what a name"];
}


- (void)testEmptyNameAndPassword {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // XCode检索控件的方法
    //    XCUIElement *textField = [[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Login"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0];
    
    // 1. 在identity inspector 中 Accessibility 面板中为控件添加identifier，然后在此处就可以使用这个identifier检索控件
//    [app.buttons[@"userLogin"] tap];
    // 2. 使用button的title作为key检索button
    [app.buttons[@"Login"] tap];
    
    [app.alerts[@"Error"].buttons[@"OK"] tap];
    
}


/**
 测试完整的登录事件
 */
- (void)testLoginOK {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *usernameTextField = app.textFields[@"userName"];
    [usernameTextField tap];
    [usernameTextField typeText:@"name"];

    
    XCUIElement *passwordTextField = app.textFields[@"password"];
    [passwordTextField tap];
    [passwordTextField typeText:@"password"];
    
    XCUIElement *loginButton = app.buttons[@"Login"];
    [loginButton tap];
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

- (void)testMyButtonEvent {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"MButton"] tap];
    NSLog(@"button frame:(%f,%f,%f,%f)", app.buttons[@"MButton"].frame.origin.x,app.buttons[@"MButton"].frame.origin.y, app.buttons[@"MButton"].frame.size.width, app.buttons[@"MButton"].frame.size.height);
}


@end
