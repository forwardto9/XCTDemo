//
//  XCTestDemoTests.m
//  XCTestDemoTests
//
//  Created by uwei on 9/21/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "TestAdvanceFunction.m"

@interface ObjectA : NSObject
- (void)pushNotification;
@property (strong, nonatomic) NSString *info;
@end

@implementation ObjectA

- (instancetype)init {
    if ([super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resovleNotification:) name:@"test.expectation.notificaion" object:nil];
    }
    return self;
}

- (void)resovleNotification:(NSNotification *)notification {
    for (int i = 0; i < 999999; ++i) {
    }
}

- (void)pushNotification {
    //  此处的第二个参数object 必须要与expectationForNotification:object:handler方法中的第二个参数属于同一个对象实例，否则将无法得到符合期望的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test.expectation.notificaion" object:self userInfo:@{@"key":@"value"}];
}

@end

@interface XCMyTestCase : XCTestCase<XCTestObservation>
@property BOOL isFinished;
@end

@implementation XCMyTestCase

// 在每一个test方法开始前，自定义条件
//- (void)setUp {
// 在整个case包含的test方法开始前，自定义条件
+ (void)setUp {
    [super setUp];
    NSLog(@"===========start============");
//    [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:self];
}

// 在每一个test方法结束后，清理工作区
//- (void)tearDown {
// 在整个case包含的test方法全部结束之后，清理工作区
+ (void)tearDown {
    [super tearDown];
    NSLog(@"===========finish============");
}

- (void)testMyMethod0 {
    NSLog(@"%s before", __FUNCTION__);
    // 在方法执行结束以后，执行block，类型将tearDown方法声明为实例方法
    [self addTeardownBlock:^{
        NSLog(@"addTeardownBlock0");
    }];
    NSLog(@"%s after", __FUNCTION__);
}

- (void)testMyMethod1 {
    NSLog(@"%s", __FUNCTION__);
    [self addTeardownBlock:^{
        NSLog(@"addTeardownBlock1");
    }];
}

- (void)testMyMethod2 {
    NSLog(@"%s", __FUNCTION__);
    NSObject *obj = nil;
    XCTAssertNotNil(obj, "obj is nil");
}

#pragma mark - Measuring Performance
- (void)testPerformance0 {
    NSLog(@"%s", __FUNCTION__);
    // 以s级来衡量block的执行时间
    [self measureBlock:^{
        NSMutableString *string = [NSMutableString new];
        for (int i = 0; i < 99999; ++i) {
            [string appendFormat:@"%d", i];
        }
    }];
}

- (void)testPerformance1 {
    NSLog(@"%s", __FUNCTION__);
    [self measureMetrics:@[XCTPerformanceMetric_WallClockTime] automaticallyStartMeasuring:NO forBlock:^{
        NSMutableString *string = [NSMutableString new];
        for (int i = 0; i < 99999; ++i) {
            if (i == 9999) {
                // 只能在block中调用一次，且需要在第二个参数为NO的条件下
                [self startMeasuring];
            }
            // 只能在block中调用一次
            if (i == 88888) {
                [self stopMeasuring];
            }
            [string appendFormat:@"%d", i];
        }
    }];
}

// 更改measure系列方法的维度参数
+ (NSArray <XCTPerformanceMetric> *)defaultPerformanceMetrics {
    // 目前就一个wallClockTime
    return @[XCTPerformanceMetric_WallClockTime];
}

#pragma mark - Testing Asynchronous Operations with Expectations
- (void)testExpectationDescription {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Download apple.com home page"];
    NSURL *url = [NSURL URLWithString:@"https://apple.com"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        XCTAssertNotNil(data, "No data was downloaded.");
        [expectation fulfill];
    }] resume];
    [self waitForExpectations:@[expectation] timeout:10.0];
}


- (void)testExpectaionNotification {
    ObjectA *objA = [[ObjectA alloc] init];
    __block NSString *value = nil;
    //    XCTNSNotificationExpectation *notificationExpectation = [[XCTNSNotificationExpectation alloc] initWithName:@"test.expectation.notificaion"];
    XCTestExpectation *expectation = [self expectationForNotification:@"test.expectation.notificaion" object:objA handler:^BOOL(NSNotification * _Nonnull notification) {
        if (notification.userInfo[@"key"]) {
            value = notification.userInfo[@"key"];
        } else {
            value = nil;
        }
        // 不能再此处调用
//        [expectation fulfill];
        
        return (value != nil);
    }];
    
    // 此处相当于任意地方触发ObjectA实例post出通知，类似按钮点击，网络交互完成等，发出通知
    [objA pushNotification];
    // 同上
    // 此处的第二个参数object 必须要与expectationForNotification:object:handler方法中的第二个参数属于同一个对象实例，否则将无法得到符合期望的通知
    //    ObjectA *objB = [[ObjectA alloc] init]; // 如果使用objB则会超时
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"test.expectation.notificaion" object:objA userInfo:@{@"key":@"value"}];
    [self waitInfoOfExpectation:expectation];
    NSLog(@"%@", value);
    XCTAssertNotNil(value, "value is nil");
}

- (void)testExpectationPredicate {
    NSString *value = @"value";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == 'value'", value];
    XCTestExpectation *expectation = [self expectationForPredicate:predicate evaluatedWithObject:value handler:^BOOL{
        return YES;
    }];
    // 此处赋值时机不对，因为predicate 已经执行完毕
    //    value = @"value";
    [self waitInfoOfExpectation:expectation];
}

- (void)testExpectationKVO1 {
    ObjectA *objA = [[ObjectA alloc] init];
    // 此处时机不正确，因为是KVO且是有isEqual的比较，不能提前赋值；另外， Swift中，KVO的属性需要声明为dynamic
    //    objA.info = @"test";
    // 因为是KVO，所以，此处的实现是将keypath添加到observe中，后续赋值的时候，将会执行KVO
    XCTestExpectation *expectation = [self keyValueObservingExpectationForObject:objA keyPath:@"info" expectedValue:@"test"];
    objA.info = @"test";
    [self waitInfoOfExpectation:expectation];
}
- (void)testExpectationKVO2 {
    ObjectA *objA = [[ObjectA alloc] init];
    objA.info = @"a";
    // 因为是KVO，所以，此处的实现是将keypath添加到observe中，后续赋值的时候，将会执行KVO
    // 此处之后的每一次对info属性赋值都会调用handler回调
    XCTestExpectation *expectation = [self keyValueObservingExpectationForObject:objA keyPath:@"info" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
        NSLog(@"%@", change);
        if ([change[@"new"] isEqual:change[@"old"]]) {
            NSLog(@"not change!");
            return NO;
        } else {
            NSLog(@"change!");
            return YES;
        }
    }];
    objA.info = @"a";
    objA.info = @"b";
    [self waitInfoOfExpectation:expectation];
}


- (void)testCaseWillStart:(XCTestCase *)testCase {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)testCaseDidFinish:(XCTestCase *)testCase {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)waitInfoOfExpectation:(XCTestExpectation *)expectation {
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5.0];
    NSString *resultDescription = nil;
    switch (result) {
        case XCTWaiterResultTimedOut:
            resultDescription = @"TimeOut";
            break;
        case XCTWaiterResultCompleted:
            resultDescription = @"Completed";
            break;
        case XCTWaiterResultInterrupted:
            resultDescription = @"Interrupted";
            break;
        case XCTWaiterResultIncorrectOrder:
            resultDescription = @"IncorrectOrder";
            break;
        case XCTWaiterResultInvertedFulfillment:
            resultDescription = @"InvertedFilfillment";
            break;
            
        default:
            break;
    }
    NSLog(@"%@ status = %@", NSStringFromClass([expectation class]), resultDescription);
}

@end

@interface XCMyTestSuite : XCTestSuite<XCTestObservation>

@end

@implementation XCMyTestSuite

- (instancetype)init {
    if (self = [super init]) {
        self = [XCMyTestSuite defaultTestSuite];
        [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:self];
    }
    return self;
}


- (void)testSuiteWillStart:(XCTestSuite *)testSuite {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)testSuiteDidFinish:(XCTestSuite *)testSuite {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end



@interface XCTestDemoTests : XCTestCase<XCTestObservation> {
    
@private
    ViewController *vc;
    
}
@end

@implementation XCTestDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [[XCTestObservationCenter sharedTestObservationCenter] addTestObserver:self];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
//    XCMyTestSuite *testSuite = [[XCMyTestSuite alloc] init]; // not working
    
    
    
    
//    XCTestSuite *testSuite = [XCTestDemoTests defaultTestSuite]; // ok
    
    // 这个方式可以从测试文件中加载测试case，然后执行。
//    XCTestSuite *testSuite = [TestAdvanceFunction defaultTestSuite]; // ok
//    XCTestSuite *testSuite = [XCTestSuite testSuiteForTestCaseClass:[XCMyTestCase class]]; // ok
    XCTestSuite *testSuite = [XCTestSuite testSuiteForTestCaseWithName:@"XCMyTestCase"]; //ok
    
//    NSString *bPath = [[NSBundle mainBundle] bundlePath];
//    XCTestSuite *testSuite = [XCTestSuite testSuiteForBundlePath:bPath]; // not working
    NSUInteger count = testSuite.tests.count;
    for (int i = 0; i < count; ++i) {
        XCTest *test = testSuite.tests[i];
        NSLog(@"Test method[%d]:%@", i, test.name);
        if (i == 0) {
            //            [test runTest];
            //            [[test testRun] start];
            //            [[test testRun] stop];
            
        }
        
        //            XCTestRun *testRun = [[XCTestRun alloc] initWithTest:test];
        XCTestRun *testRun = [XCTestRun testRunWithTest:test];
        
//        [testRun start]; // not working
        [test performTest:testRun];
        if (testRun.hasSucceeded) {
            NSLog(@"OK");
        } else {
            NSLog(@"NO");
        }
    }
}

- (void)testMethod {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testA {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testZ {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testBundle {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"bundle" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:file];
    // XCAssert是一系列可用的断言宏
    XCTAssertNotNil(data);
    XCTAssertNil([data objectForKey:@"key"]);
    NSLog(@"[Test] bundle data: %@", data);
}

- (void)testCaseWillStart:(XCTestCase *)testCase {
    NSLog(@"%s", __FUNCTION__);
}

- (void)testCaseDidFinish:(XCTestCase *)testCase {
    NSLog(@"%s", __FUNCTION__);
}

@end
