#import "LwaPlugin.h"
#if __has_include(<lwa/lwa-Swift.h>)
#import <lwa/lwa-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lwa-Swift.h"
#endif

@implementation LwaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLwaPlugin registerWithRegistrar:registrar];
}
@end
