#import "scriptedmain.h"
#import <Foundation/Foundation.h>

@implementation ScriptedMain

+ (int)meaningOfLife {
	return 42;
}

@end

int __attribute__((weak)) main(int argc, char **argv) {
	@autoreleasepool {

		printf("Main: The meaning of life is %d\n", [ScriptedMain meaningOfLife]);

	}

	return 0;
}
