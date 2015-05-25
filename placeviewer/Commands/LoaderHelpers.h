#ifndef placeviewer_LoaderHelpers_h
#define placeviewer_LoaderHelpers_h

typedef NS_ENUM(NSInteger, LoadingState) {
  LoadingStateNotStarted = 0,
  LoadingStateLoading,
  LoadingStateFinished,
  LoadingStateFailed
};

static NSString *const kLoaderErrorDomain = @"Network loader error.";

#endif
