#import "AppDelegate.h"

#import <CocoaLumberjack.h>

#import "State.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
  self.window.rootViewController = [[ViewController alloc] initWithState:[[State alloc] init]];
  [self.window makeKeyAndVisible];

  return YES;
}

@end
