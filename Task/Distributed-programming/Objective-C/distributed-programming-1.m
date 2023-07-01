#import <Foundation/Foundation.h>
// our protocol allows "sending" "strings", but we can implement
// everything we could for a "local" object
@protocol ActionObjectProtocol
- (NSString *)sendMessage: (NSString *)msg;
@end
