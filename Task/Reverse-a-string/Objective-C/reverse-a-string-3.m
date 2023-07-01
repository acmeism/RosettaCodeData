#import <Foundation/Foundation.h>

@interface NSString (Extended)
-(NSString *)reverseString;
@end

@implementation NSString (Extended)
-(NSString *)reverseString
{
	NSInteger l = [self length] - 1;
	NSMutableString *ostr = [NSMutableString stringWithCapacity:[self length]];
	while (l >= 0)
	{
		NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:l];
		[ostr appendString:[self substringWithRange:range]];
		l -= range.length;
	}
	return ostr;
}
@end
