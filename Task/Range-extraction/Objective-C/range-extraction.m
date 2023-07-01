#import <Foundation/Foundation.h>

NSString *extractRanges(NSArray *nums) {
  NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
  for (NSNumber *n in nums) {
    if ([n integerValue] < 0)
      @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"negative number not supported" userInfo:nil];
    [indexSet addIndex:[n unsignedIntegerValue]];
  }
  NSMutableString *s = [[NSMutableString alloc] init];
  [indexSet enumerateRangesUsingBlock:^(NSRange range, BOOL *stop) {
    if (s.length)
      [s appendString:@","];
    if (range.length == 1)
      [s appendFormat:@"%lu", range.location];
    else if (range.length == 2)
      [s appendFormat:@"%lu,%lu", range.location, range.location+1];
    else
      [s appendFormat:@"%lu-%lu", range.location, range.location+range.length-1];
  }];
  return s;
}

int main() {
  @autoreleasepool {

    NSLog(@"%@", extractRanges(@[@0, @1, @2, @4, @6, @7, @8, @11, @12, @14,
                                 @15, @16, @17, @18, @19, @20, @21, @22, @23, @24,
                                 @25, @27, @28, @29, @30, @31, @32, @33, @35, @36,
                                 @37, @38, @39]));

  }
  return 0;
}
