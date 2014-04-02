#import <Foundation/Foundation.h>

int main(int argc, char **argv)
{
    while (--argc) {
        int i = atoi(argv[argc]);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, i * NSEC_PER_SEC),
                       dispatch_get_main_queue(),
                       ^{ NSLog(@"%d\n", i); });
    }
}
