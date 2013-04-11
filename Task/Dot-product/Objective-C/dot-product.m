#import <stdio.h>
#import <stdint.h>
#import <stdlib.h>
#import <string.h>
#import <objc/Object.h>

// this class exists to return a result between two
// vectors: if vectors have different "size", valid
// must be NO
@interface VResult : Object
{
 @private
  double value;
  BOOL valid;
}
+(id)new: (double)v isValid: (BOOL)y;
-(id)init: (double)v isValid: (BOOL)y;
-(BOOL)isValid;
-(double)value;
@end

@implementation VResult
+(id)new: (double)v isValid: (BOOL)y
{
  id s = [super new];
  [s init: v isValid: y];
  return s;
}
-(id)init: (double)v isValid: (BOOL)y
{
  value = v;
  valid = y;
  return self;
}
-(BOOL)isValid { return valid; }
-(double)value { return value; }
@end


@interface RCVector : Object
{
 @private
  double *vec;
  uint32_t size;
}
+(id)newWithArray: (double *)v ofLength: (uint32_t)l;
-(id)initWithArray: (double *)v ofLength: (uint32_t)l;
-(VResult *)dotProductWith: (RCVector *)v;
-(uint32_t)size;
-(double *)array;
-(void)free;
@end

@implementation RCVector
+(id)newWithArray: (double *)v ofLength: (uint32_t)l
{
  id s = [super new];
  [s initWithArray: v ofLength: l];
  return s;
}
-(id)initWithArray: (double *)v ofLength: (uint32_t)l
{
  size = l;
  vec = malloc(sizeof(double) * l);
  if ( vec != NULL ) {
    memcpy(vec, v, sizeof(double)*l);
    return self;
  }
  [super free];
  return nil;
}
-(void)free
{
  free(vec);
  [super free];
}
-(uint32_t)size { return size; }
-(double *)array { return vec; }
-(VResult *)dotProductWith: (RCVector *)v
{
  double r = 0.0;
  uint32_t i, s;
  double *v1;
  if ( [self size] != [v size] ) return [VResult new: r isValid: NO];
  s = [self size];
  v1 = [v array];
  for(i = 0; i < s; i++) {
    r += vec[i] * v1[i];
  }
  return [VResult new: r isValid: YES];
}
@end

double val1[] = { 1, 3, -5 };
double val2[] = { 4,-2, -1 };

int main()
{
  RCVector *v1 = [RCVector newWithArray: val1 ofLength: sizeof(val1)/sizeof(double)];
  RCVector *v2 = [RCVector newWithArray: val2 ofLength: sizeof(val1)/sizeof(double)];
  VResult *r = [v1 dotProductWith: v2];
  if ( [r isValid] ) {
    printf("%lf\n", [r value]);
  } else {
    fprintf(stderr, "length of vectors differ\n");
  }
  return 0;
}
