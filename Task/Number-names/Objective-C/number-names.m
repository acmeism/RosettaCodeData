#import <Foundation/Foundation.h>

int main() {
  @autoreleasepool {

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterSpellOutStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    for (NSNumber *n in @[@900000001, @1234567890, @-987654321, @0, @3.14]) {
      NSLog(@"%@", [numberFormatter stringFromNumber:n]);
    }

  }
  return 0;
}
