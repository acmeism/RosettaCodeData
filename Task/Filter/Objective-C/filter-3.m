#import <Foundation/Foundation.h>

@interface NSNumber ( ExtFunc )
-(int) modulo2;
@end

@implementation NSNumber ( ExtFunc )
-(int) modulo2
{
  return [self intValue] % 2;
}
@end

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSArray *numbers = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                               [NSNumber numberWithInt:2],
                                               [NSNumber numberWithInt:3],
                                               [NSNumber numberWithInt:4],
                                               [NSNumber numberWithInt:5], nil];

  NSPredicate *isEven = [NSPredicate predicateWithFormat:@"modulo2 == 0"];
  NSArray *evens = [numbers filteredArrayUsingPredicate:isEven];

  NSLog(@"%@", evens);


  [pool release];
  return 0;
}
