#include <Foundation/Foundation.h>

typedef id (^Function)(id);

// a commodity for "encapsulating" double f(double)
typedef double (*func_t)(double);
Function encapsulate(func_t f) {
  return [[^(id x) { return [NSNumber numberWithDouble: f([x doubleValue])]; } copy] autorelease];
}

Function compose(Function a, Function b) {
  return [[^(id x) { return a(b(x)); } copy] autorelease];
}

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

  Function f = encapsulate(my_f);
  Function g = encapsulate(my_g);

  Function composed = compose(f, g);

  printf("g(2.0) = %lf\n", [g([NSNumber numberWithDouble: 2.0]) doubleValue]);
  printf("f(2.0) = %lf\n", [f([NSNumber numberWithDouble: 2.0]) doubleValue]);
  printf("f(g(2.0)) = %lf\n", [composed([NSNumber numberWithDouble: 2.0]) doubleValue]);

  [pool release];
  return 0;
}
