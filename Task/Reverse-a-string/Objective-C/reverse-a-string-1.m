#import <Foundation/Foundation.h>

@interface NSString (Extended)
-(NSString *)reverseString;
@end

@implementation NSString (Extended)
-(NSString *) reverseString
{
    NSUInteger len = [self length];
    NSMutableString *rtr=[NSMutableString stringWithCapacity:len];
    //        unichar buf[1];

    while (len > (NSUInteger)0) {
        unichar uch = [self characterAtIndex:--len];
        [rtr appendString:[NSString stringWithCharacters:&uch length:1]];
    }
    return rtr;
}
@end
