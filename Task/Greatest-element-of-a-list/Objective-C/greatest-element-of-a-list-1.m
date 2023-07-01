#import <Foundation/Foundation.h>

@interface NSArray (WithMaximum)
- (id)maximumValue;
@end

@implementation NSArray (WithMaximum)
- (id)maximumValue
{
  if ( [self count] == 0 ) return nil;
  id maybeMax = self[0];
  for ( id el in self ) {
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
