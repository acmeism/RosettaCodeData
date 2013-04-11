#import <Foundation/Foundation.h>

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSArray *strings = [@"Here are some sample strings to be sorted" componentsSeparatedByString:@" "];

  NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"length" ascending:NO];
  NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"lowercaseString" ascending:YES];

  NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
  [sd1 release];
  [sd2 release];

  NSArray *sorted = [strings sortedArrayUsingDescriptors:sortDescriptors];
  NSLog(@"%@", sorted);

  [pool release];

  return 0;
}
