#import "PlaceImageLoader.h"

#import <AFHTTPRequestOperationManager+RACSupport.h>

#import "Place.h"

static NSString *const kImageEndpointFormat = @"%ld/%@";

@implementation PlaceImageLoader

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFImageResponseSerializer serializer];
  }
  return self;
}

- (void)loadImageForPlace:(Place *)place {
  if (place.image) return;

  place.imageLoadingState = LoadingStateLoading;

  NSString *endpoint = [NSString stringWithFormat:kImageEndpointFormat, place.id, place.imageName];
  RACSignal *signal = [self rac_GET:endpoint parameters:nil];
  [signal subscribeNext:^(UIImage *image) {
    place.image = image;
    place.imageLoadingState = LoadingStateFinished;
  } error:^(NSError *error) {
    place.imageLoadingState = LoadingStateFailed;
  }];
}

@end
