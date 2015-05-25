#import <UIKit/UIKit.h>

@class Place;

@interface PlaceCell : UICollectionViewCell

+ (NSString *)identifier;

+ (CGFloat)expectedHeight;

@property(nonatomic) Place *place;

@end
