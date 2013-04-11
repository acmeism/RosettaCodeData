#import <Foundation/Foundation.h>

@interface Example : NSObject {
@private
  NSString *_name;
}
- (id)initWithName:(NSString *)name;
@end

@implementation Example
- (NSString *)description {
  return [NSString stringWithFormat:@"Hello, I am %@", _name];
}
- (id)initWithName:(NSString *)name {
  if ((self = [super init])) {
    _name = [name copy];
  }
  return self;
}
- (void)dealloc {
  [_name release];
  [super dealloc];
}
@end

int main (int argc, const char * argv[]) {
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  Example *foo = [[Example alloc] initWithName:@"Eric"];

  // get private field
  NSLog(@"%@", foo->_name);

  // set private field
  [foo->_name release];
  foo->_name = [@"Edith" copy];
  NSLog(@"%@", foo);

  [foo release];

  [pool release];
  return 0;
}
