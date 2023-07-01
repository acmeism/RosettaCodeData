#import <Foundation/Foundation.h>

int main(void) {
  @autoreleasepool {
    NSDictionary *base = @{@"name": @"Rocket Skates", @"price": @12.75, @"color": @"yellow"};
    NSDictionary *update = @{@"price": @15.25, @"color": @"red", @"year": @1974};

    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:base];
    [result addEntriesFromDictionary:update];

    NSLog(@"%@", result);
  }
  return 0;
}
