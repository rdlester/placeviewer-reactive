#import "PlaceLoader.h"

#import <AFHTTPRequestOperationManager+RACSupport.h>
#import <CocoaLumberjack.h>

#import "PlaceArray.h"
#import "State.h"

static NSString *const kPlacesEndpoint = @"gistfile1.json";

@implementation PlaceLoader

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    // Allow "text/plain" content-type repsonses. Needed to work with gists.
    NSMutableSet *acceptableContentTypes =
        [NSMutableSet setWithSet:self.responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"text/plain"];
    self.responseSerializer.acceptableContentTypes = acceptableContentTypes;
  }
  return self;
}

- (void)loadPlacesForState:(State *)state {
  state.placesLoadingState = LoadingStateLoading;
  RACSignal *signal = [[self rac_GET:kPlacesEndpoint parameters:nil]
                       flattenMap:^id(NSArray *placesJSON) {
                         // Parse repsonse into Model object.
                         if ([placesJSON isKindOfClass:[NSArray class]]) {
                           return [RACSignal return:[[PlaceArray alloc] initFromJSON:placesJSON]];
                         } else {
                           NSString *errorMessage = @"Unexpected response from places endpoint.";
                           return [RACSignal error:[NSError errorWithDomain:nil
                                                                       code:0
                                                                   userInfo:@{NSLocalizedDescriptionKey: errorMessage}]];
                         }
                       }];;

  // Update state.
  [signal subscribeNext:^(PlaceArray *placeArray) {
    state.places = placeArray;
    state.placesLoadingState = LoadingStateFinished;
  } error:^(NSError *error) {
    DDLogError(@"Error loading places: %@", error.localizedDescription);
    state.placesLoadingState = LoadingStateFailed;
  }];
}

@end
