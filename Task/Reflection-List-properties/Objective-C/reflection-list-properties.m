#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Foo : NSObject {
  int exampleIvar;
}
@property (nonatomic) double exampleProperty;
@end
@implementation Foo
- (instancetype)init {
  self = [super init];
  if (self) {
    exampleIvar = 42;
    _exampleProperty = 3.14;
  }
  return self;
}
@end

int main() {
  id obj = [[Foo alloc] init];
  Class clazz = [obj class];

  NSLog(@"\Instance variables:");
  unsigned int ivarCount;
  Ivar *ivars = class_copyIvarList(clazz, &ivarCount);
  for (unsigned int i = 0; i < ivarCount; i++) {
    Ivar ivar = ivars[i];
    const char *name = ivar_getName(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    // for simple types we can use Key-Value Coding to access it
    // but in general we will have to use object_getIvar and cast it to the right type of function
    // corresponding to the type of the instance variable
    id value = [obj valueForKey:@(name)];
    NSLog(@"%s\t%s\t%@", name, typeEncoding, value);
  }
  free(ivars);

  NSLog(@"");
  NSLog(@"Properties:");
  unsigned int propCount;
  objc_property_t *properties = class_copyPropertyList([Foo class], &propCount);
  for (unsigned int i = 0; i < propCount; i++) {
    objc_property_t p = properties[i];
    const char *name = property_getName(p);
    const char *attributes = property_getAttributes(p);
    // for simple types we can use Key-Value Coding to access it
    // but in general we will have to use objc_msgSend to call the getter,
    // casting objc_msgSend to the right type of function corresponding to the type of the getter
    id value = [obj valueForKey:@(name)];
    NSLog(@"%s\t%s\t%@", name, attributes, value);
  }
  free(properties);

  return 0;
}
