#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WcFlutterSharePlugin.h"

FOUNDATION_EXPORT double wc_flutter_shareVersionNumber;
FOUNDATION_EXPORT const unsigned char wc_flutter_shareVersionString[];

