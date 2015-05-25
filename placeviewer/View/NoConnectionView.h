#import <UIKit/UIKit.h>

@class RACSignal;

@interface NoConnectionView : UIView

@property(nonatomic, readonly) RACSignal *reloadSignal;

@end
