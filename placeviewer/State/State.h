#import <Foundation/Foundation.h>

#import "LoaderHelpers.h"

@class PlaceArray;
@class PlaceImageLoader;
@class PlaceLoader;

/**
 * Represents the complete state of the application at any given moment in time.
 */
@interface State : NSObject

// Master list of places loaded from server.
@property(nonatomic) PlaceArray *places;
@property(nonatomic) LoadingState placesLoadingState;

@end
