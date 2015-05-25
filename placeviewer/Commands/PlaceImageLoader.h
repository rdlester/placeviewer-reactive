#import <AFNetworking.h>

@class Place;

/**
 * Loads images of place given the place id and image name.
 */
@interface PlaceImageLoader : AFHTTPRequestOperationManager

- (instancetype)initWithBaseURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

- (void)loadImageForPlace:(Place *)place;

@end
