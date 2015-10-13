#import <Foundation/Foundation.h>

int main() {
    @autoreleasepool {
        NSFileHandle *standardOutput = [NSFileHandle fileHandleWithStandardOutput];
        NSString *message = @"Hello, World!\n";
        [standardOutput writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    }
}
