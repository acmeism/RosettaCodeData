@interface Camera : NSObject {
}
@end

@implementation Camera
@end

@interface MobilePhone : NSObject {
}
@end

@implementation MobilePhone
@end

@interface CameraPhone : NSObject {
  Camera *camera;
  MobilePhone *phone;
}
@end

@implementation CameraPhone

-(instancetype)init {
  if ((self = [super init])) {
    camera = [[Camera alloc] init];
    phone = [[MobilePhone alloc] init];
  }
  return self;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
  SEL aSelector = [anInvocation selector];
  if ([camera respondsToSelector:aSelector])
    [anInvocation invokeWithTarget:camera];
  else if ([phone respondsToSelector:aSelector])
    [anInvocation invokeWithTarget:phone];
  else
    [self doesNotRecognizeSelector:aSelector];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  return [camera methodSignatureForSelector:aSelector]
  ?: [phone methodSignatureForSelector:aSelector]
  ?: [super methodSignatureForSelector:aSelector];
}

-(BOOL)respondsToSelector:(SEL)aSelector {
  return [camera respondsToSelector:aSelector]
  || [phone respondsToSelector:aSelector]
  || [super respondsToSelector:aSelector];
}

@end
