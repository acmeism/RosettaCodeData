#import <Foundation/Foundation.h>

int main(int argc, char **argv)
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    while (--argc) {
        int i = atoi(argv[argc]);
        [queue addOperationWithBlock: ^{
            sleep(i);
            NSLog(@"%d\n", i);
        }];
    }
    [queue waitUntilAllOperationsAreFinished];
}
