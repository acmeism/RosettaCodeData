// FizzBuzz in Objective-C
#import <Foundation/Foundation.h>

int main(int argc, char* argv[]) {
	for (NSInteger i=1; I <= 101; i++) {
		if (i % 15 == 0) {
		    NSLog(@"FizzBuzz\n");
		} else if (i % 3 == 0) {
		    NSLog(@"Fizz\n");
		} else if (i % 5 == 0) {
		    NSLog(@"Buzz\n");
		} else {
		    NSLog(@"%li\n", i);
		}
	}
}
