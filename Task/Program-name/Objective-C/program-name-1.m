#import <Foundation/Foundation.h>

int main(int argc, char **argv) {
	@autoreleasepool {

		char *program = argv[0];
		printf("Program: %s\n", program);

		// Alternatively:
		NSString *program2 = [[NSProcessInfo processInfo] processName];
		NSLog(@"Program: %@\n", program2);

	}

	return 0;
}
