#include <Foundation/Foundation.h>

// The methods need to be declared somewhere
@interface Dummy : NSObject { }
- (void)grill;
- (void)ding:(NSString *)s;
@end

@interface Example : NSObject { }
- (void)foo;
- (void)bar;
@end

@implementation Example
- (void)foo {
  NSLog(@"this is foo");
}
- (void)bar {
  NSLog(@"this is bar");
}
- (void)forwardInvocation:(NSInvocation *)inv {
  NSLog(@"tried to handle unknown method %@", NSStringFromSelector([inv selector]));
  unsigned n = [[inv methodSignature] numberOfArguments];
  unsigned i;
  for (i = 0; i < n-2; i++) { // first two arguments are the object and selector
    id arg;                   // we assume that all arguments are objects
    [inv getArgument:&arg atIndex:i+2];
    NSLog(@"argument #%u: %@", i, arg);
  }
}
// forwardInvocation: does not work without methodSignatureForSelector:
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  int numArgs = [[NSStringFromSelector(aSelector) componentsSeparatedByString:@":"] count] - 1;
  // we assume that all arguments are objects
  // The type encoding is "v@:@@@...", where "v" is the return type, void
  // "@" is the receiver, object type; ":" is the selector of the current method;
  // and each "@" after corresponds to an object argument
  return [NSMethodSignature signatureWithObjCTypes:
          [[@"v@:" stringByPaddingToLength:numArgs+3 withString:@"@" startingAtIndex:0] UTF8String]];
}
@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  id example = [[Example alloc] init];

  [example foo];          // prints "this is foo"
  [example bar];          // prints "this is bar"
  [example grill];        // prints "tried to handle unknown method grill"
  [example ding:@"dong"]; // prints "tried to handle unknown method ding:"
                          // prints "argument #0: dong"
  [example release];

  [pool release];

  return 0;
}
