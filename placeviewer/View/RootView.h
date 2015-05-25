#import <UIKit/UIKit.h>

@class RACSignal;
@class State;

@interface RootView : UIView

@property(nonatomic) State *state;

@property(nonatomic, readonly) RACSignal *reloadSignal;

@end
