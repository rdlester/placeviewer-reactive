#import <UIKit/UIKit.h>

#import "LoaderHelpers.h"

/**
 * Model object representing a place.
 */
@interface Place : NSObject

// Properties deserialized from JSON.
@property(nonatomic) NSInteger id;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *imageName;
@property(nonatomic) NSString *location;
@property(nonatomic) CGFloat latitude;
@property(nonatomic) CGFloat longitude;

// Elements loaded from additional network requests.
@property(nonatomic) UIImage *image;
@property(nonatomic) LoadingState imageLoadingState;

// Properties of UX state.
@property(nonatomic) BOOL visible;
@property(nonatomic) BOOL favorited;
@property(nonatomic) BOOL discarded;

- (instancetype)initWithJSONDict:(NSDictionary *)jsonDict NS_DESIGNATED_INITIALIZER;

@end
