#import <Foundation/Foundation.h>

typedef double (^Func)(double); // a block that takes a double and returns a double

Func sdCreator() {
  __block int n = 0;
  __block double sum = 0;
  __block double sum2 = 0;
  return ^(double x) {
    sum += x;
    sum2 += x*x;
    n++;
    return sqrt(sum2/n - sum*sum/n/n);
  };
}

int main()
{
  @autoreleasepool {

    double v[] = { 2,4,4,4,5,5,7,9 };

    Func sdacc = sdCreator();

    for(int i=0; i < sizeof(v)/sizeof(*v) ; i++)
      printf("adding %f\tstddev = %f\n", v[i], sdacc(v[i]));

  }
  return 0;
}
