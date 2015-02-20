@import Foundation;

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // Create a mutable array
        NSMutableArray *doorArray = [@[] mutableCopy];

        // Fill the doorArray with 100 closed doors
        for (NSInteger i = 0; i < 100; ++i) {
            doorArray[i] = @NO;
        }

        // Do the 100 passes
        for (NSInteger pass = 0; pass < 100; ++pass) {
            for (NSInteger door = pass; door < 100; door += pass+1) {
                doorArray[door] = [doorArray[door]  isEqual: @YES] ? @NO : @YES;
            }
        }

        // Print the results
        [doorArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqual: @YES]) {
                NSLog(@"Door number %lu is open", idx + 1);
            }
        }];
    }
}
