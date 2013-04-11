@interface NSString (CountSubstrings)
- (NSUInteger)occurrencesOfSubstring:(NSString *)subStr;
@end

@implementation NSString (CountSubstrings)
- (NSUInteger)occurrencesOfSubstring:(NSString *)subStr {
  return ([self length] - [[self stringByReplacingOccurrencesOfString:subStr withString:@""] length]) / [subStr length];
}
@end

int main(int argc, const char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  NSLog(@"%lu", [@"the three truths" occurrencesOfSubstring:@"th"]);
  NSLog(@"%lu", [@"ababababab" occurrencesOfSubstring:@"abab"]);
  NSLog(@"%lu", [@"abaabba*bbaba*bbab" occurrencesOfSubstring:@"a*b"]);

  [pool release];
  return 0;
}
