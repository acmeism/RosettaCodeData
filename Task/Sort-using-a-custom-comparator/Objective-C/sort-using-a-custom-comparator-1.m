#import <Foundation/Foundation.h>

#define esign(X) (((X)>0)?1:(((X)<0)?-1:0))

int main()
{
  @autoreleasepool {

    NSMutableArray *arr =
    [NSMutableArray
      arrayWithArray: [@"this is a set of strings to sort"
                       componentsSeparatedByString: @" "]
     ];

    [arr sortUsingComparator: ^NSComparisonResult(id obj1, id obj2){
      NSComparisonResult l = esign((int)([obj1 length] - [obj2 length]));
      return l ? -l // reverse the ordering
               : [obj1 caseInsensitiveCompare: obj2];
     }];

    for( NSString *str in arr )
    {
      NSLog(@"%@", str);
    }

  }
  return EXIT_SUCCESS;
}
