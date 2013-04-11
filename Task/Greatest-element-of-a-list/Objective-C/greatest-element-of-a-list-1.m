#import <Foundation/Foundation.h>

@interface NSArray (WithMaximum)
- (id)maximumValue;
@end

@implementation NSArray (WithMaximum)
- (id)maximumValue
{
  if ( [self count] == 0 ) return nil;
  id maybeMax = [self objectAtIndex: 0];
  NSEnumerator *en = [self objectEnumerator];
  id el;
  while ( (el=[en nextObject]) != nil ) {
    if ( [maybeMax respondsToSelector: @selector(compare:)] &&
	 [el respondsToSelector: @selector(compare:)]       &&
	 [el isKindOfClass: [NSNumber class]]               &&
	 [maybeMax isKindOfClass: [NSNumber class]] ) {
      if ( [maybeMax compare: el] == NSOrderedAscending )
	maybeMax = el;
    } else { return nil; }
  }
  return maybeMax;
}
@end
