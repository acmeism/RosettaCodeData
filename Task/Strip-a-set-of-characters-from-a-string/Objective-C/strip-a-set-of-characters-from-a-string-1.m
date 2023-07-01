@interface NSString (StripCharacters)
- (NSString *) stripCharactersInSet: (NSCharacterSet *) chars;
@end

@implementation NSString (StripCharacters)
- (NSString *) stripCharactersInSet: (NSCharacterSet *) chars {
    return [[self componentsSeparatedByCharactersInSet:chars] componentsJoinedByString:@""];
}
@end
