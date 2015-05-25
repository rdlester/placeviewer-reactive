#import "Place.h"

// Constants mapping properties to JSON keys.
static NSString *const kIdKey = @"id";
static NSString *const kTitleKey = @"title";
static NSString *const kImageNameKey = @"image";
static NSString *const kLocationKey = @"location";
static NSString *const kLatitudeKey = @"latitude";
static NSString *const kLongitudeKey = @"longitude";

@implementation Place

- (instancetype)initWithJSONDict:(NSDictionary *)jsonDict {
  self = [super init];
  if (self) {
    self.id = [jsonDict[kIdKey] integerValue];
    self.title = jsonDict[kTitleKey];
    self.imageName = jsonDict[kImageNameKey];
    self.location = jsonDict[kLocationKey];
    self.latitude = [jsonDict[kLatitudeKey] floatValue];
    self.longitude = [jsonDict[kLongitudeKey] floatValue];
  }
  return self;
}

@end
