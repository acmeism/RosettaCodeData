#include <Foundation/Foundation.h>

// the protocol of objects that can behave "like function"
@protocol FunctionCapsule <NSObject>
-(id)computeWith: (id)x;
@end


// a commodity for "encapsulating" double f(double)
typedef double (*func_t)(double);
@interface FunctionCaps : NSObject <FunctionCapsule>
{
  func_t function;
}
+(id)capsuleFor: (func_t)f;
-(id)initWithFunc: (func_t)f;
@end

@implementation FunctionCaps
-(id)initWithFunc: (func_t)f
{
  if ((self = [self init])) {
    function = f;
  }
  return self;
}
+(id)capsuleFor: (func_t)f
{
  return [[[self alloc] initWithFunc: f] autorelease];
}
-(id)computeWith: (id)x
{
  return [NSNumber numberWithDouble: function([x doubleValue])];
}
@end


// the "functions" composer
@interface FunctionComposer : NSObject <FunctionCapsule>
{
  id<FunctionCapsule> funcA;
  id<FunctionCapsule> funcB;
}
+(id) createCompositeFunctionWith: (id<FunctionCapsule>)A and: (id<FunctionCapsule>)B;
-(id) initComposing: (id<FunctionCapsule>)A with: (id<FunctionCapsule>)B;
@end

@implementation FunctionComposer
+(id) createCompositeFunctionWith: (id<FunctionCapsule>)A and: (id<FunctionCapsule>)B
{
  return [[[self alloc] initComposing: A with: B] autorelease];
}

-(id) init
{
  [self release];
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:@"FunctionComposer: init with initComposing!"
                               userInfo:nil];
  return nil;
}

-(id) initComposing: (id<FunctionCapsule>)A with: (id<FunctionCapsule>)B
{
  if ((self = [super init])) {
    if ( [A respondsToSelector: @selector(computeWith:)] &&
         [B respondsToSelector: @selector(computeWith:)] ) {
      funcA = [A retain]; funcB = [B retain];
      return self;
    }
    NSLog(@"FunctionComposer: cannot compose functions not responding to protocol FunctionCapsule!");
    [self release];
  }
  return nil;
}

-(id)computeWith: (id)x
{
  return [funcA computeWith: [funcB computeWith: x]];
}

-(void) dealloc
{
  [funcA release];
  [funcB release];
  [super dealloc];
}
@end


// functions outside...
double my_f(double x)
{
  return x+1.0;
}

double my_g(double x)
{
  return x*x;
}


int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  id<FunctionCapsule> funcf = [FunctionCaps capsuleFor: my_f];
  id<FunctionCapsule> funcg = [FunctionCaps capsuleFor: my_g];

  id<FunctionCapsule> composed = [FunctionComposer
		                   createCompositeFunctionWith: funcf and: funcg];

  printf("g(2.0) = %lf\n", [[funcg computeWith: [NSNumber numberWithDouble: 2.0]] doubleValue]);
  printf("f(2.0) = %lf\n", [[funcf computeWith: [NSNumber numberWithDouble: 2.0]] doubleValue]);
  printf("f(g(2.0)) = %lf\n", [[composed computeWith: [NSNumber numberWithDouble: 2.0]] doubleValue]);

  [pool release];
  return 0;
}
