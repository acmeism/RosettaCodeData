#import "TowersOfHanoi.h"
@implementation TowersOfHanoi

-(void) setPegFrom: (int) from andSetPegTo: (int) to andSetPegVia: (int) via andSetNumDisks: (int) disks {
	pegFrom = from;
	pegTo = to;
	pegVia = via;
	numDisks = disks;
}

-(void) movePegFrom: (int) from andMovePegTo: (int) to andMovePegVia: (int) via andWithNumDisks: (int) disks {
	if (disks == 1) {
            printf("Move disk from pole %i to pole %i\n", from, to);
        } else {
 			[self movePegFrom: from andMovePegTo: via andMovePegVia: to andWithNumDisks: disks-1];
			[self movePegFrom: from andMovePegTo: to andMovePegVia: via andWithNumDisks: 1];
			[self movePegFrom: via andMovePegTo: to andMovePegVia: from andWithNumDisks: disks-1];
        }
}

@end
