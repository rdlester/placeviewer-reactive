#import <UIKit/UIKit.h>

@class RACSignal;

typedef NS_ENUM(NSInteger, PlacesFilter) {
  PlacesFilterNormal = 0,  // All places except those marked as discarded.
  PlacesFilterAll,
  PlacesFilterFavorites
};

/**
 * The complete list of places currently obtained by the application.
 * Also exposes signals over special properties across all places, eg. selection.
 */
@interface PlaceArray : NSObject

// Contains elements of type `Place`.
@property(nonatomic) PlacesFilter currentPlacesFilter;
@property(nonatomic, readonly) NSArray *currentPlaces;
@property(nonatomic, readonly) RACSignal *currentPlacesUpdated;

@property(nonatomic, readonly) RACSignal *discardedSignal;
@property(nonatomic, readonly) RACSignal *visibleSignal;
@property(nonatomic, readonly) RACSignal *favoriteSignal;

- (instancetype)initFromJSON:(NSArray *)json NS_DESIGNATED_INITIALIZER;

@end
