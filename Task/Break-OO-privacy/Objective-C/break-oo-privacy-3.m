#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Example : NSObject {
@private
  NSString *_name;
}
- (instancetype)initWithName:(NSString *)name;
@end

@implementation Example
- (NSString *)description {
  return [NSString stringWithFormat:@"Hello, I am %@", _name];
}
- (instancetype)initWithName:(NSString *)name {
  if ((self = [super init])) {
    _name = [name copy];
  }
  return self;
}
@end

int main (int argc, const char * argv[]) {
  @autoreleasepool{

    Example *foo = [[Example alloc] initWithName:@"Eric"];

    // get private field
    Ivar nameField = class_getInstanceVariable([foo class], "_name");
    NSLog(@"%@", object_getIvar(foo, nameField));

    // set private field
    object_setIvar(foo, nameField, @"Edith");
    NSLog(@"%@", foo);

  }
  return 0;
}
