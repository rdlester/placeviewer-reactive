#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <ObjectiveSugar.h>
#import <ReactiveCocoa.h>

@interface TestObj : NSObject
@property(nonatomic) BOOL discard;
@end

@implementation TestObj
@end

@interface placeviewerTests : XCTestCase

@end

@implementation placeviewerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
  @weakify(self);
  XCTestExpectation *exp = [self expectationWithDescription:@"fjlf"];
  NSArray *array = @[[[TestObj alloc] init], [[TestObj alloc] init], [[TestObj alloc] init]];
  [array[1] setDiscard:YES];
  RACSignal *signal = [[[array.rac_sequence signal] flattenMap:^RACStream *(TestObj *obj) {
    @strongify(self);
    RACStream *observe = RACObserve(obj, discard);
    return observe;
  }] skip:array.count];
  [signal subscribeNext:^(id x) {
    [exp fulfill];
  }];
  [signal asynchronousFirstOrDefault:nil success:nil error:nil];
  NSArray *array2 = [array select:^BOOL(TestObj *obj) {
    return obj.discard;
  }];
  [array2[0] setDiscard:NO];
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
