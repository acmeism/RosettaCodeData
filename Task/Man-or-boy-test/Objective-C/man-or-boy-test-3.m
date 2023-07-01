@protocol IntegerFun <NSObject>
-(NSInteger)call;
@end

NSInteger A (NSInteger kParam, id<IntegerFun> x1, id<IntegerFun> x2, id<IntegerFun> x3, id<IntegerFun> x4, id<IntegerFun> x5);

@interface B_Class : NSObject <IntegerFun> {
  NSInteger *k;
  id<IntegerFun> x1, x2, x3, x4;
}
-(id)initWithK:(NSInteger *)k x1:(id<IntegerFun>)x1 x2:(id<IntegerFun>)x2 x3:(id<IntegerFun>)x3 x4:(id<IntegerFun>)x4;
@end

@implementation B_Class
-(id)initWithK:(NSInteger *)_k x1:(id<IntegerFun>)_x1 x2:(id<IntegerFun>)_x2 x3:(id<IntegerFun>)_x3 x4:(id<IntegerFun>)_x4 {
  if ((self = [super init])) {
    k = _k;
    x1 = [_x1 retain];
    x2 = [_x2 retain];
    x3 = [_x3 retain];
    x4 = [_x4 retain];
  }
  return self;
}
-(void)dealloc {
  [x1 release];
  [x2 release];
  [x3 release];
  [x4 release];
  [super dealloc];
}
-(NSInteger)call {
  return A(--*k, self, x1, x2, x3, x4);
}
@end

NSInteger A (NSInteger k, id<IntegerFun> x1, id<IntegerFun> x2, id<IntegerFun> x3, id<IntegerFun> x4, id<IntegerFun> x5) {
  id<IntegerFun> B = [[[B_Class alloc] initWithK:&k x1:x1 x2:x2 x3:x3 x4:x4] autorelease];
  return k <= 0 ? [x4 call] + [x5 call] : [B call];
}

@interface K : NSObject <IntegerFun> {
  NSInteger n;
}
-(id)initWithN:(NSInteger)n;
@end

@implementation K
-(id)initWithN:(NSInteger)_n {
  if ((self = [super init])) {
    n = _n;
  }
  return self;
}
-(NSInteger)call {
  return n;
}
@end

int main(int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSInteger result = A(10,
                       [[[K alloc] initWithN:1] autorelease],
                       [[[K alloc] initWithN:-1] autorelease],
                       [[[K alloc] initWithN:-1] autorelease],
                       [[[K alloc] initWithN:1] autorelease],
                       [[[K alloc] initWithN:0] autorelease]);
  NSLog(@"%ld\n", result);

  [pool release];
  return 0;
}
