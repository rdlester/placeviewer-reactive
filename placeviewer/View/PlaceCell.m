#import "PlaceCell.h"

#import <ReactiveCocoa.h>

#import "Place.h"

static const CGFloat kImageWidth = 50;
static const CGFloat kTitleY = 5;
static const CGFloat kPaddingX = 5;

@implementation PlaceCell {
  UILabel *_title;
  UILabel *_location;
  UIImageView *_imageView;
  UIActivityIndicatorView *_imageLoadingIndicator;

  UIButton *_favoriteButton;
  UIButton *_discardButton;

  RACDisposable *_placeImageSignal;
}

+ (NSString *)identifier {
  return @"PlaceCellIdentifier";
}

+ (CGFloat)expectedHeight {
  return 100;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];

    _title = [[UILabel alloc] init];
    _title.textColor = [UIColor blackColor];
    _title.lineBreakMode = NSLineBreakByTruncatingTail;
    _title.numberOfLines = 1;
    [self.contentView addSubview:_title];

    _location = [[UILabel alloc] init];
    _location.textColor = [UIColor blackColor];
    _location.lineBreakMode = NSLineBreakByTruncatingTail;
    _location.numberOfLines = 1;
    [self.contentView addSubview:_location];

    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];

    _imageLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_imageLoadingIndicator];

    _favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favoriteButton setTitle:@"Fav" forState:UIControlStateNormal];
    [_favoriteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_favoriteButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    [self.contentView addSubview:_favoriteButton];

    _discardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_discardButton setTitle:@"Del" forState:UIControlStateNormal];
    [_discardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_discardButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.contentView addSubview:_discardButton];

    [self attachButtonSignals];
  }
  return self;
}

- (void)layoutSubviews {
  CGRect imageFrame, titleFrame, locationFrame, favoriteFrame, discardFrame;
  CGRectDivide(self.contentView.frame, &imageFrame, &titleFrame, kImageWidth, CGRectMinXEdge);
  _imageView.frame = imageFrame;
  _imageLoadingIndicator.frame = imageFrame;

  [_title sizeToFit];
  titleFrame = _title.frame;
  titleFrame.origin.x = CGRectGetMaxX(_imageView.frame) + kPaddingX;
  titleFrame.origin.y = kTitleY;
  _title.frame = titleFrame;

  [_location sizeToFit];
  locationFrame = _location.frame;
  locationFrame.origin.x = CGRectGetMaxX(_imageView.frame) + kPaddingX;
  locationFrame.origin.y = CGRectGetMaxY(_title.frame);
  _location.frame = locationFrame;

  [_favoriteButton sizeToFit];
  favoriteFrame = _favoriteButton.frame;
  favoriteFrame.origin.x = CGRectGetMaxX(_imageView.frame) + kPaddingX;
  favoriteFrame.origin.y = CGRectGetMaxY(_location.frame);
  _favoriteButton.frame = favoriteFrame;

  [_discardButton sizeToFit];
  discardFrame = _discardButton.frame;
  discardFrame.origin.x = CGRectGetMaxX(_favoriteButton.frame) + kPaddingX;
  discardFrame.origin.y = CGRectGetMaxY(_location.frame);
  _discardButton.frame = discardFrame;
}

- (void)attachButtonSignals {
  [[_favoriteButton rac_signalForControlEvents:UIControlEventTouchUpInside]
  subscribeNext:^(UIButton *sender) {
    if (_place) {
      _place.favorited = !_place.favorited;
      sender.selected = _place.favorited;
    }
  }];
  [[_discardButton rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(UIButton *sender) {
     if (_place) {
       _place.discarded = !_place.discarded;
       sender.selected = _place.discarded;
     }
   }];
}

- (void)setPlace:(Place *)place {
  _place = place;

  _title.text = _place.title;
  _location.text = _place.location;

  _favoriteButton.selected = _place.favorited;
  _discardButton.selected = _place.discarded;

  [self setupImageSignal];

  _place.visible = YES;
}

- (void)setupImageSignal {
  _placeImageSignal = [RACObserve(_place, imageLoadingState)
                       subscribeNext:^(NSNumber *imageLoadingState) {
                         switch ([imageLoadingState integerValue]) {
                           case LoadingStateNotStarted:
                           case LoadingStateLoading:
                             _imageLoadingIndicator.hidden = NO;
                             [_imageLoadingIndicator startAnimating];
                             _imageView.hidden = YES;
                             break;

                           case LoadingStateFinished:
                             _imageLoadingIndicator.hidden = YES;
                             [_imageLoadingIndicator stopAnimating];
                             _imageView.hidden = NO;
                             _imageView.image = _place.image;
                             break;

                           case LoadingStateFailed:
                             break;
                         }
                       }];
}

- (void)prepareForReuse {
  [_placeImageSignal dispose];
  _imageView.image = nil;
}

@end
