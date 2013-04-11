#import <Foundation/Foundation.h>

@interface NSArray (FlattenExt)
@property (nonatomic, readonly) NSArray *flattened;
@end

@implementation NSArray (FlattenExt)
-(NSArray *) flattened {
    NSMutableArray *flattened = [[NSMutableArray alloc] initWithCapacity:self.count];

    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]])
            [flattened addObjectsFromArray:((NSArray *)object).flattened];
        else
            [flattened addObject:object];
    }

    return [flattened autorelease];
}
@end

int main() {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray *unflattened = [NSArray arrayWithObjects:[NSArray arrayWithObject:[NSNumber numberWithInteger:1]],
                           [NSNumber numberWithInteger:2],
                           [NSArray arrayWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInteger:3], [NSNumber numberWithInteger:4], nil],
                           [NSNumber numberWithInteger:5], nil],
                           [NSArray arrayWithObject:[NSArray arrayWithObject:[NSArray array]]],
                           [NSArray arrayWithObject:[NSArray arrayWithObject:[NSArray arrayWithObject:[NSNumber numberWithInteger:6]]]],
                           [NSNumber numberWithInteger:7],
                           [NSNumber numberWithInteger:8],
                           [NSArray array], nil];

    for (id object in unflattened.flattened)
        NSLog(@"%@", object);

    [pool drain];

    return 0;
}
