#import <Foundation/Foundation.h>

void runSystemCommand(NSString *cmd)
{
    [[NSTask launchedTaskWithLaunchPath:@"/bin/sh"
        arguments:[NSArray arrayWithObjects:@"-c", cmd, nil]]
        waitUntilExit];
}

int main(int argc, const char **argv)
{
    NSAutoreleasePool *pool;

    pool = [NSAutoreleasePool new];

    runSystemCommand(@"ls");
    [pool release];
    return 0;
}
