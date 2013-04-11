#import <Foundation/Foundation.h>

int main(int argc, char **argv) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	char *program = argv[0];
	printf("Program: %s\n", program);

	// Alternatively:
	NSString *program2 = [[NSProcessInfo processInfo] processName];
	NSLog(@"Program: %@\n", program2);

	[pool drain];

	return 0;
}
