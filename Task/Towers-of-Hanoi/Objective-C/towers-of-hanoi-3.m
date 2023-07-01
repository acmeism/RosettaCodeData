#import <stdio.h>
#import "TowersOfHanoi.h"

int main( int argc, const char *argv[] ) {
	@autoreleasepool {

		TowersOfHanoi *tower = [[TowersOfHanoi alloc] init];

		int from = 1;
		int to = 3;
		int via = 2;
		int disks = 3;

		[tower setPegFrom: from andSetPegTo: to andSetPegVia: via andSetNumDisks: disks];

		[tower movePegFrom: from andMovePegTo: to andMovePegVia: via andWithNumDisks: disks];

	}
	return 0;
}
