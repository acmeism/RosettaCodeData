#import <Foundation/Foundation.h>

CFComparisonResult myComparator(const void *x, const void *y, void *context) {
  return [(id)x compare:(id)y];
}

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSArray *a = [NSArray arrayWithObjects:
		   [NSNumber numberWithInt: 1],
		   [NSNumber numberWithInt: 3],
		   [NSNumber numberWithInt: 4],
		   [NSNumber numberWithInt: 5],
		   [NSNumber numberWithInt: 6],
		   [NSNumber numberWithInt: 7],
		   [NSNumber numberWithInt: 8],
		   [NSNumber numberWithInt: 9],
		   [NSNumber numberWithInt: 10],
		   nil];
  NSLog(@"6 is at position %d", CFArrayBSearchValues((CFArrayRef)a,
                                                     CFRangeMake(0, [a count]),
                                                     [NSNumber numberWithInt: 6],
                                                     myComparator,
                                                     NULL)); // prints 4

  [pool drain];
  return 0;
}
