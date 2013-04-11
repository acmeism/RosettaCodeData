#import <Foundation/Foundation.h>

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
  NSLog(@"6 is at position %lu", [a indexOfObject:[NSNumber numberWithInt: 6]
                                    inSortedRange:NSMakeRange(0, [a count])
                                          options:0
                                  usingComparator:^(id x, id y){ return [x compare: y]; }]); // prints 4

  [pool drain];
  return 0;
}
