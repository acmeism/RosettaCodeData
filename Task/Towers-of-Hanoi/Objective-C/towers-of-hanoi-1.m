#import <Foundation/NSObject.h>

@interface TowersOfHanoi: NSObject {
	int pegFrom;
	int pegTo;
	int pegVia;
	int numDisks;
}

-(void) setPegFrom: (int) from andSetPegTo: (int) to andSetPegVia: (int) via andSetNumDisks: (int) disks;
-(void) movePegFrom: (int) from andMovePegTo: (int) to andMovePegVia: (int) via andWithNumDisks: (int) disks;
@end
