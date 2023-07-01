#import <Foundation/Foundation.h>

@interface SDAccum : NSObject
{
  double sum, sum2;
  unsigned int num;
}
-(double)value: (double)v;
-(unsigned int)count;
-(double)mean;
-(double)variance;
-(double)stddev;
@end

@implementation SDAccum
-(double)value: (double)v
{
  sum += v;
  sum2 += v*v;
  num++;
  return [self stddev];
}
-(unsigned int)count
{
  return num;
}
-(double)mean
{
  return (num>0) ? sum/(double)num : 0.0;
}
-(double)variance
{
  double m = [self mean];
  return (num>0) ? (sum2/(double)num - m*m) : 0.0;
}
-(double)stddev
{
  return sqrt([self variance]);
}
@end

int main()
{
  @autoreleasepool {

    double v[] = { 2,4,4,4,5,5,7,9 };

    SDAccum *sdacc = [[SDAccum alloc] init];

    for(int i=0; i < sizeof(v)/sizeof(*v) ; i++)
      printf("adding %f\tstddev = %f\n", v[i], [sdacc value: v[i]]);

  }
  return 0;
}
