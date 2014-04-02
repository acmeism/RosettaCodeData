#import <Foundation/Foundation.h>

@interface NSString (CustomComp)
- (NSComparisonResult)my_compare: (id)obj;
@end

#define esign(X) (((X)>0)?1:(((X)<0)?-1:0))
@implementation NSString (CustomComp)
- (NSComparisonResult)my_compare: (id)obj
{
  NSComparisonResult l = esign((int)([self length] - [obj length]));
  return l ? -l // reverse the ordering
           : [self caseInsensitiveCompare: obj];
}
@end

int main()
{
  @autoreleasepool {

    NSMutableArray *arr =
       [NSMutableArray
         arrayWithArray: [@"this is a set of strings to sort"
                           componentsSeparatedByString: @" "]
       ];

    [arr sortUsingSelector: @selector(my_compare:)];

    for ( NSString *str in arr )
    {
      NSLog(@"%@", str);
    }

  }
  return EXIT_SUCCESS;
}
