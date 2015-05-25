#import "HeaderView.h"

#import <ReactiveCocoa.h>

#import "PlaceArray.h"

@implementation HeaderView {
  UITextField *_searchField;

  UIButton *_favoritesFilterButton;
  BOOL _favoritesFilterOn;

  UIButton *_listLayoutButton;
  UIButton *_photoLayoutButton;

  UIView *_divider;

  PlaceArray *_placeArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];

    _favoritesFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favoritesFilterButton setTitle:@"Fav Filter" forState:UIControlStateNormal];
    [_favoritesFilterButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_favoritesFilterButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    [self addSubview:_favoritesFilterButton];

    _divider = [[UIView alloc] init];
    _divider.backgroundColor = [UIColor grayColor];
    [self addSubview:_divider];

    [self addButtonSignals];
  }
  return self;
}

- (void)layoutSubviews {
  [_favoritesFilterButton sizeToFit];
  _favoritesFilterButton.frame = CGRectMake(0, 0, CGRectGetWidth(_favoritesFilterButton.frame), CGRectGetHeight(_favoritesFilterButton.frame));

  _divider.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
}

- (void)addButtonSignals {
  [[_favoritesFilterButton rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(UIButton *sender) {
     _favoritesFilterOn = !_favoritesFilterOn;
     _placeArray.currentPlacesFilter = _favoritesFilterOn ? PlacesFilterFavorites : PlacesFilterNormal;
     sender.selected = _favoritesFilterOn;
   }];
}

- (void)setPlaceArray:(PlaceArray *)placeArray {
  _placeArray = placeArray;
}

@end
