#import <Foundation/Foundation.h>

@interface Example : NSObject { }
- (NSNumber *)foo;
@end

@implementation Example
- (NSNumber *)foo {
  return [NSNumber numberWithInt:42];
}
@end

int main (int argc, const char *argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  id example = [[Example alloc] init];
  SEL selector = @selector(foo); // or = NSSelectorFromString(@"foo");
  NSLog(@"%@", [example performSelector:selector]);
  [example release];

  [pool release];
  return 0;
}
