@interface NSString (RosettaCodeAddition)
- (NSString *) repeatStringByNumberOfTimes: (NSUInteger) times;
@end

@implementation NSString (RosettaCodeAddition)
- (NSString *) repeatStringByNumberOfTimes: (NSUInteger) times {
    return [@"" stringByPaddingToLength:[self length]*times withString:self startingAtIndex:0];
}
@end
