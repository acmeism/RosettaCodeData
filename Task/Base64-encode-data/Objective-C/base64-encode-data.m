#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://rosettacode.org/favicon.ico"]];
    NSLog(@"%@", [data base64Encoding]);
  }
  return 0;
}
