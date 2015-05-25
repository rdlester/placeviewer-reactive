#import <UIKit/UIKit.h>

@class State;

/**
 * Root view controller. Connects view hierarchy to iOS system calls.
 */
@interface ViewController : UIViewController

- (instancetype)initWithState:(State *)state NS_DESIGNATED_INITIALIZER;

@end
