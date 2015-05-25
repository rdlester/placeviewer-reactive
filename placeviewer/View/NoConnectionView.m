#import "NoConnectionView.h"

#import <ReactiveCocoa.h>

static const CGFloat kReloadButtonYOffset = 10;

@implementation NoConnectionView {
  UILabel *_message;
  UIButton *_reloadButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _message = [[UILabel alloc] init];
    _message.text = @"Connection lost.";
    [self addSubview:_message];

    _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
    [_reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _reloadSignal = [_reloadButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reloadButton];
  }
  return self;
}

- (void)layoutSubviews {
  [_message sizeToFit];
  _message.frame = CGRectMake(self.center.x - CGRectGetWidth(_message.frame) / 2,
                             self.center.y - CGRectGetHeight(_message.frame),
                             CGRectGetWidth(_message.frame),
                             CGRectGetHeight(_message.frame));

  [_reloadButton sizeToFit];
  _reloadButton.frame = CGRectMake(self.center.x - CGRectGetWidth(_reloadButton.frame) / 2,
                                   self.center.y + kReloadButtonYOffset,
                                   CGRectGetWidth(_reloadButton.frame),
                                   CGRectGetHeight(_reloadButton.frame));
}

@end
