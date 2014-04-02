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

@interface Example (HackName)
- (NSString *)getName;
- (void)setNameTo:(NSString *)newName;
@end

@implementation Example (HackName)
- (NSString *)getName {
  return _name;
}
- (void)setNameTo:(NSString *)newName {
  _name = [newName copy];
}
@end

int main (int argc, const char * argv[]) {
  @autoreleasepool{

    Example *foo = [[Example alloc] initWithName:@"Eric"];

    // get private field
    NSLog(@"%@", [foo getName]);

    // set private field
    [foo setNameTo:@"Edith"];
    NSLog(@"%@", foo);

  }
  return 0;
}
