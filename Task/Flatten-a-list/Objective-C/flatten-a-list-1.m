#import <Foundation/Foundation.h>

@interface NSArray (FlattenExt)
-(NSArray *)flatten;
@end

@implementation NSArray (FlattenExt)
-(NSArray *)flatten
{
  NSMutableArray *r = [NSMutableArray array];
  NSEnumerator *en = [self objectEnumerator];
  id o;
  while ( (o = [en nextObject]) ) {
    if ( [o isKindOfClass: [NSArray class]] )
      [r addObjectsFromArray: [o flatten]];
    else
      [r addObject: o];
  }
  return [NSArray arrayWithArray: r];
}
@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSArray *p = [NSArray
		 arrayWithObjects:
		   [NSArray arrayWithObjects: [NSNumber numberWithInt: 1], nil],
		   [NSNumber numberWithInt: 2],
		   [NSArray arrayWithObjects:
			    [NSArray arrayWithObjects: [NSNumber numberWithInt: 3],
				     [NSNumber numberWithInt: 4], nil],
			  [NSNumber numberWithInt: 5], nil],
		   [NSArray arrayWithObjects:
			    [NSArray arrayWithObjects:
				       [NSArray arrayWithObjects: nil], nil], nil],
		   [NSArray arrayWithObjects:
			    [NSArray arrayWithObjects:
				       [NSArray arrayWithObjects:
						  [NSNumber numberWithInt: 6], nil], nil], nil],
		   [NSNumber numberWithInt: 7],
		   [NSNumber numberWithInt: 8],
		   [NSArray arrayWithObjects: nil], nil];
  NSArray *f = [p flatten];
  NSEnumerator *e = [f objectEnumerator];
  id o;
  while( (o = [e nextObject]) )
  {
    NSLog(@"%@", o);
  }
				

  [pool drain];
  return 0;
}
