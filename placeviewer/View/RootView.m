#import "RootView.h"

#import <ReactiveCocoa.h>

#import "HeaderView.h"
#import "NoConnectionView.h"
#import "PlaceArray.h"
#import "PlaceCollectionView.h"
#import "State.h"

static const CGFloat kHeaderHeight = 100;

@implementation RootView {
  HeaderView *_header;
  PlaceCollectionView *_collectionView;
  UIActivityIndicatorView *_placesLoadingIndicator;

  NoConnectionView *_errorMessage;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];

    _header = [[HeaderView alloc] init];
    [self addSubview:_header];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[PlaceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:_collectionView];

    _placesLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_placesLoadingIndicator];

    _errorMessage = [[NoConnectionView alloc] init];
    _errorMessage.hidden = YES;
    [self addSubview:_errorMessage];
  }
  return self;
}

- (void)layoutSubviews {
  _header.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kHeaderHeight);

  CGRect mainFrame = CGRectMake(0, kHeaderHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - kHeaderHeight);
  _collectionView.frame = mainFrame;
  _placesLoadingIndicator.frame = mainFrame;
  _errorMessage.frame = mainFrame;
}

- (void)setState:(State *)state {
  _state = state;

  [RACObserve(_state, placesLoadingState)
  subscribeNext:^(NSNumber *placesLoadingState) {
    switch ([placesLoadingState integerValue]) {
      case LoadingStateNotStarted:
      case LoadingStateLoading:
        _placesLoadingIndicator.hidden = NO;
        [_placesLoadingIndicator startAnimating];
        _collectionView.hidden = YES;
        _errorMessage.hidden = YES;
        break;

      case LoadingStateFinished:
        _placesLoadingIndicator.hidden = YES;
        [_placesLoadingIndicator stopAnimating];
        _collectionView.hidden = NO;
        _collectionView.placeArray = _state.places;
        _header.placeArray = _state.places;
        _errorMessage.hidden = YES;
        break;

      case LoadingStateFailed:
        _placesLoadingIndicator.hidden = YES;
        [_placesLoadingIndicator stopAnimating];
        _collectionView.hidden = YES;
        _errorMessage.hidden = NO;
        break;
    }
  }];
}

- (RACSignal *)reloadSignal {
  return _errorMessage.reloadSignal;
}

@end
