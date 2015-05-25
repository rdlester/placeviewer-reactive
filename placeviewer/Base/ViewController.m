#import "ViewController.h"

#import <ReactiveCocoa.h>

#import "Place.h"
#import "PlaceArray.h"
#import "PlaceImageLoader.h"
#import "PlaceLoader.h"
#import "RootView.h"
#import "State.h"

static NSString *const kPlacesBaseURLString =
    @"https://gist.githubusercontent.com/rdlester/734e4f1ab194b8db23d8/raw/"
    @"7e04c3d88f6c06d7a794ae570f39a96107b18457";
static NSString *const kImageBaseURLString =
    @"https://travelpoker-production.s3.amazonaws.com/uploads/card/image";

@interface ViewController ()

@property(nonatomic) RootView *view;

@end

@implementation ViewController {
  State *_state;

  RACDisposable *_imageLoaderSubscriber;
}

@dynamic view;

- (instancetype)initWithState:(State *)state {
  self = [super init];
  if (self) {
    _state = state;
  }
  return self;
}

- (void)loadView {
  self.view = [[RootView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (void)viewDidLoad {
  @weakify(self);

  self.view.state = _state;

  if (!_state.places) {
    [self loadPlaces];
  }

  [self.view.reloadSignal subscribeNext:^(id x) {
    @strongify(self);
    [self loadPlaces];
  }];
}

- (void)loadPlaces {
  [_imageLoaderSubscriber dispose];

  NSURL *placesBaseURL = [NSURL URLWithString:kPlacesBaseURLString];
  PlaceLoader *loader = [[PlaceLoader alloc] initWithBaseURL:placesBaseURL];

  [loader loadPlacesForState:_state];

  // Load image for a place once the place becomes visible.
  NSURL *imageBaseURL = [NSURL URLWithString:kImageBaseURLString];
  PlaceImageLoader *imageLoader = [[PlaceImageLoader alloc] initWithBaseURL:imageBaseURL];
  _imageLoaderSubscriber = [[RACObserve(_state, places) flattenMap:^RACStream *(PlaceArray *places) {
    return places.visibleSignal;
  }] subscribeNext:^(Place *place) {
    if (place.visible) {
      [imageLoader loadImageForPlace:place];
    }
  }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
