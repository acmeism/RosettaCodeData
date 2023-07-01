@interface NSString (CountSubstrings)
- (NSUInteger)occurrencesOfSubstring:(NSString *)subStr;
@end

@implementation NSString (CountSubstrings)
- (NSUInteger)occurrencesOfSubstring:(NSString *)subStr {
  return [[self componentsSeparatedByString:subStr] count] - 1;
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
