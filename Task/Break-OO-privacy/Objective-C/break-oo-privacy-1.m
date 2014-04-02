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
@end

int main (int argc, const char * argv[]) {
  @autoreleasepool{

    Example *foo = [[Example alloc] initWithName:@"Eric"];

    // get private field
    NSLog(@"%@", [foo valueForKey:@"name"]);

    // set private field
    [foo setValue:@"Edith" forKey:@"name"];
    NSLog(@"%@", foo);

  }
  return 0;
}
