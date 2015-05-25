#import <AFNetworking.h>

@class RACSignal;
@class State;

/**
 * Loader that handles obtaining place information.
 */
@interface PlaceLoader : AFHTTPRequestOperationManager

- (instancetype)initWithBaseURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

- (void)loadPlacesForState:(State *)state;

@end
