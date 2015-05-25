#import "PlaceArray.h"

#import <CocoaLumberjack.h>
#import <ObjectiveSugar.h>
#import <ReactiveCocoa.h>

#import "Place.h"

@implementation PlaceArray {
  NSArray *_allPlaces;
  NSMutableArray *_currentPlaces;
  RACDisposable *_currentPlacesUpdateSignal;

  NSMutableArray *_currentPlacesUpdatedSubscribers;
}

- (instancetype)initFromJSON:(NSArray *)json {
  self = [super init];
  if (self) {
    _allPlaces = [json map:^id(NSDictionary *jsonPlace) {
      assert([jsonPlace isKindOfClass:[NSDictionary class]]);
      return [[Place alloc] initWithJSONDict:jsonPlace];
    }];

    _currentPlacesUpdatedSubscribers = [NSMutableArray array];
    _currentPlacesUpdated = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      [_currentPlacesUpdatedSubscribers addObject:subscriber];
      return [RACDisposable disposableWithBlock:^{
        [_currentPlacesUpdatedSubscribers removeObject:subscriber];
      }];
    }];

    self.currentPlacesFilter = PlacesFilterNormal;
  }
  return self;
}

- (void)setCurrentPlacesFilter:(PlacesFilter)currentPlacesFilter {
  @weakify(self);
  [_currentPlacesUpdateSignal dispose];
  _currentPlacesFilter = currentPlacesFilter;

  switch (currentPlacesFilter) {
    case PlacesFilterNormal: {
      _currentPlaces = [[_allPlaces select:^BOOL(Place *place) {
        return !place.discarded;
      }] mutableCopy];
      _currentPlacesUpdateSignal = [self.discardedSignal subscribeNext:^(Place *place) {
        @strongify(self);
        if (place.discarded) {
          [_currentPlaces removeObject:place];
        } else {
          [_currentPlaces addObject:place];
        }
        [self notifySubscribers];
      }];
      break;
    }

    case PlacesFilterFavorites: {
      _currentPlaces = [[_allPlaces select:^BOOL(Place *place) {
        return place.favorited;
      }] mutableCopy];
      _currentPlacesUpdateSignal = [self.favoriteSignal subscribeNext:^(Place *place) {
        @strongify(self);
        if (place.favorited) {
          [_currentPlaces addObject:place];
        } else {
          [_currentPlaces removeObject:place];
        }
        [self notifySubscribers];
      }];
      break;
    }

    case PlacesFilterAll:
      _currentPlaces = [_allPlaces mutableCopy];
      _currentPlacesUpdateSignal = nil;
      break;
  }

  [self notifySubscribers];
}

- (void)notifySubscribers {
  [_currentPlacesUpdatedSubscribers each:^(id<RACSubscriber> subscriber) {
    [subscriber sendNext:nil];
  }];
}

- (NSArray *)currentPlaces {
  return _currentPlaces;
}

- (RACSignal *)discardedSignal {
  @weakify(self);
  return [[_allPlaces.rac_sequence signal] flattenMap:^RACStream *(Place *place) {
    // For each place, observe its `discarded` property.
    @strongify(self);
    RACSignal *visibleSignal = RACObserve(place, discarded);
    return [[visibleSignal map:^Place *(NSNumber *discarded) {
      return place;
    }] skip:1];
  }];
}

- (RACSignal *)visibleSignal {
  @weakify(self);
  return [[_allPlaces.rac_sequence signal] flattenMap:^RACStream *(Place *place) {
    // For each place, observe its `discarded` property.
    @strongify(self);
    RACSignal *visibleSignal = RACObserve(place, visible);
    return [[visibleSignal map:^Place *(NSNumber *visible) {
      DDLogDebug(@"Visible changed to: %@", visible);
      return place;
    }] skip:1];
  }];
}

- (RACSignal *)favoriteSignal {
  @weakify(self);
  return [[_allPlaces.rac_sequence signal] flattenMap:^RACStream *(Place *place) {
    // For each place, observe its `discarded` property.
    @strongify(self);
    RACSignal *favoriteSignal = RACObserve(place, favorited);
    return [[favoriteSignal map:^Place *(NSNumber *favorited) {
      return place;
    }] skip:1];
  }];
}

@end
