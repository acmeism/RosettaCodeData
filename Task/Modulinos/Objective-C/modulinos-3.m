#import "scriptedmain.h"
#import <Foundation/Foundation.h>

int main(int argc, char **argv) {
	@autoreleasepool {

		printf("Test: The meaning of life is %d\n", [ScriptedMain meaningOfLife]);

	}

	return 0;
}
