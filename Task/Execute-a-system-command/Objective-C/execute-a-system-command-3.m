#import <Foundation/Foundation.h>

void runSystemCommand(NSString *cmd)
{
    [[NSTask launchedTaskWithLaunchPath:@"/bin/sh"
        arguments:@[@"-c", cmd]]
        waitUntilExit];
}

int main(int argc, const char **argv)
{
    @autoreleasepool {

      runSystemCommand(@"ls");
    }
    return 0;
}
