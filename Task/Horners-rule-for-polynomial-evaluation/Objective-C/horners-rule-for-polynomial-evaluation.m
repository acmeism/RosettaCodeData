#import <Foundation/Foundation.h>

typedef double (^mfunc)(double, double);

@interface NSArray (HornerRule)
- (double)horner: (double)x;
- (NSArray *)reversedArray;
- (double)injectDouble: (double)s with: (mfunc)op;
@end

@implementation NSArray (HornerRule)
- (NSArray *)reversedArray
{
  return [[self reverseObjectEnumerator] allObjects];
}


- (double)injectDouble: (double)s with: (mfunc)op
{
  double sum = s;
  for(NSNumber* el in self) {
    sum = op(sum, [el doubleValue]);
  }
  return sum;
}

- (double)horner: (double)x
{
  return [[self reversedArray] injectDouble: 0.0 with: ^(double s, double a) { return s * x + a; } ];
}
@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSArray *coeff = [NSArray
		     arrayWithObjects:
		       [NSNumber numberWithDouble: -19.0],
       		       [NSNumber numberWithDouble: 7.0],
		       [NSNumber numberWithDouble: -4.0],
		       [NSNumber numberWithDouble: 6.0], nil];
  printf("%f\n", [coeff horner: 3.0]);

  [pool release];
  return 0;
}
