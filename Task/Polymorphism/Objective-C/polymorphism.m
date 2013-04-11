#import <Foundation/Foundation.h>

@interface RCPoint : NSObject {
  int x, y;
}
-(id)initWithX:(int)x0;
-(id)initWithX:(int)x0 andY:(int)y0;
-(id)initWithPoint:(RCPoint *)p;
@property (nonatomic) int x;
@property (nonatomic) int y;
@end

@implementation RCPoint
@synthesize x, y;
-(id)initWithX:(int)x0 { return [self initWithX:x0 andY:0]; }
-(id)initWithX:(int)x0 andY:(int)y0 {
  if ((self = [super init])) {
    x = x0;
    y = y0;
  }
  return self;
}
-(id)initWithPoint:(RCPoint *)p { return [self initWithX:p.x andY:p.y]; }
-(NSString *)description { return [NSString stringWithFormat:@"<RCPoint %p x: %d y: %d>", self, x, y]; }
@end

@interface RCCircle : RCPoint {
  int r;
}
-(id)initWithCenter:(RCPoint *)p andRadius:(int)r0;
-(id)initWithX:(int)x0 andY:(int)y0 andRadius:(int)r0;
-(id)initWithCircle:(RCCircle *)c;
@property (nonatomic) int r;
@end

@implementation RCCircle
@synthesize r;
-(id)initWithCenter:(RCPoint *)p andRadius:(int)r0 {
  if ((self = [super initWithPoint:p])) {
    r = r0;
  }
  return self;
}
-(id)initWithX:(int)x0 andY:(int)y0 andRadius:(int)r0 {
  if ((self = [super initWithX:x0 andY:y0])) {
    r = r0;
  }
  return self;
}
-(id)initWithCircle:(RCCircle *)c { return [self initWithX:c.x andY:c.y andRadius:c.r]; }
-(NSString *)description { return [NSString stringWithFormat:@"<RCCircle %p x: %d y: %d r: %d>", self, x, y, r]; }
@end

int main(int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSLog(@"%@", [[[RCPoint alloc] init] autorelease]);
  NSLog(@"%@", [[[RCPoint alloc] initWithX:3] autorelease]);
  NSLog(@"%@", [[[RCPoint alloc] initWithX:3 andY:4] autorelease]);
  NSLog(@"%@", [[[RCCircle alloc] init] autorelease]);
  NSLog(@"%@", [[[RCCircle alloc] initWithX:3] autorelease]);
  NSLog(@"%@", [[[RCCircle alloc] initWithX:3 andY:4] autorelease]);
  NSLog(@"%@", [[[RCCircle alloc] initWithX:3 andY:4 andRadius:7] autorelease]);
  RCPoint *p = [[[RCPoint alloc] initWithX:1 andY:2] autorelease];
  NSLog(@"%@", [[[RCCircle alloc] initWithPoint:p] autorelease]);
  NSLog(@"%@", [[[RCCircle alloc] initWithCenter:p andRadius:7] autorelease]);
  NSLog(@"%d", p.x); // 1
  p.x = 8;
  NSLog(@"%d", p.x); // 8

  [pool release];
  return 0;
}
