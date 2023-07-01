#import <Foundation/Foundation.h>

int main()
{
  @autoreleasepool {

    NSArray *strings = [@"Here are some sample strings to be sorted" componentsSeparatedByString:@" "];

    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"length" ascending:NO];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"lowercaseString" ascending:YES];

    NSArray *sorted = [strings sortedArrayUsingDescriptors:@[sd1, sd2]];
    NSLog(@"%@", sorted);

  }

  return 0;
}
