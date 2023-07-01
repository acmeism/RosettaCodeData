#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Foo : NSObject
@end
@implementation Foo
- (int)bar:(double)x {
  return 42;
}
@end

int main() {
  unsigned int methodCount;
  Method *methods = class_copyMethodList([Foo class], &methodCount);
  for (unsigned int i = 0; i < methodCount; i++) {
    Method m = methods[i];
    SEL selector = method_getName(m);
    const char *typeEncoding = method_getTypeEncoding(m);
    NSLog(@"%@\t%s", NSStringFromSelector(selector), typeEncoding);
  }
  free(methods);
  return 0;
}
