#import <Foundation/Foundation.h>

@interface NSArray (BinarySearchRecursive)
// Requires all elements of this array to implement a -compare: method which
// returns a NSComparisonResult for comparison.
// Returns NSNotFound when not found
- (NSInteger) binarySearch:(id)key inRange:(NSRange)range;
@end

@implementation NSArray (BinarySearchRecursive)
- (NSInteger) binarySearch:(id)key inRange:(NSRange)range {
  if (range.length == 0)
    return NSNotFound;
  NSInteger mid = range.location + range.length / 2;
  id midVal = [self objectAtIndex:mid];
  switch ([midVal compare:key]) {
  case NSOrderedAscending:
    return [self binarySearch:key
                      inRange:NSMakeRange(mid + 1, NSMaxRange(range) - (mid + 1))];
  case NSOrderedDescending:
    return [self binarySearch:key
                      inRange:NSMakeRange(range.location, mid - range.location)];
  default:
    return mid;
  }
}
@end

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
  NSLog(@"6 is at position %d", [a binarySearch:[NSNumber numberWithInt: 6]
                                        inRange:NSMakeRange(0, [a count])]); // prints 4

  [pool drain];
  return 0;
}
