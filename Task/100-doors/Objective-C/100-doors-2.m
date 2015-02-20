@import Foundation;

#pragma mark - Classes
////////////////////////////////////////////////////
// Model class header - A we are using a category to add a method to MSMutableArray
@interface NSMutableArray (DoorModelExtension)

- (void)setNumberOfDoors:(NSUInteger)doors;

@end

// Model class implementation
@implementation NSMutableArray (DoorModelExtension)

- (void)setNumberOfDoors:(NSUInteger)doors {
    // Fill the doorArray with 100 closed doors
    for (NSInteger i = 0; i < doors; ++i) {
        self[i] = @NO;
    }
}
@end
////////////////////////////////////////////////////

// View class header - A simple class to handle printing our values
@interface DoorViewClass : NSObject

- (void)printResultsOfDoorTask:(NSMutableArray *)doors;

@end

// View class implementation
@implementation DoorViewClass

- (void)printResultsOfDoorTask:(NSMutableArray *)doors {

    // Print the results, using an enumeration block for easy index tracking
    [doors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual: @YES]) {
            NSLog(@"Door number %lu is open", idx + 1);
        }
    }];
}

@end
////////////////////////////////////////////////////

#pragma mark - main
// With our classes set we can use them from our controller, in this case main
int main(int argc, const char * argv[]) {

    // Init our classes
    NSMutableArray *doorArray = [NSMutableArray array];
    DoorViewClass *doorView = [DoorViewClass new];

    // Use our class category to add the doors
    [doorArray setNumberOfDoors:100];

    // Do the 100 passes
    for (NSUInteger pass = 0; pass < 100; ++pass) {
        for (NSUInteger door = pass; door < 100; door += pass+1) {
            doorArray[door] = [doorArray[door]  isEqual: @YES] ? @NO : @YES;
        }
    }

    // Print the results
    [doorView printResultsOfDoorTask:doorArray];

}
