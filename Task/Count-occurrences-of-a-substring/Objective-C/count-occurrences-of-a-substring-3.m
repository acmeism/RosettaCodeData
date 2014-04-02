@interface NSString (CountSubstrings)
- (NSUInteger)occurrencesOfSubstring:(NSString *)subStr;
@end

@implementation NSString (CountSubstrings)
- (NSUInteger)occurrencesOfSubstring:(NSString *)subStr {
  NSUInteger count = 0;
  for (NSRange range = [self rangeOfString:subStr]; range.location != NSNotFound;
       range.location += range.length,
       range = [self rangeOfString:subStr options:0
                             range:NSMakeRange(range.location, [self length] - range.location)])
    count++;
  return count;
}
@end

int main(int argc, const char *argv[]) {
  @autoreleasepool {

    NSLog(@"%lu", [@"the three truths" occurrencesOfSubstring:@"th"]);
    NSLog(@"%lu", [@"ababababab" occurrencesOfSubstring:@"abab"]);
    NSLog(@"%lu", [@"abaabba*bbaba*bbab" occurrencesOfSubstring:@"a*b"]);

  }
  return 0;
}
