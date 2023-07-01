void runSystemCommand(NSString *cmd)
{
    [[NSTask launchedTaskWithLaunchPath:@"/bin/sh"
        arguments:@[@"-c", cmd]]
        waitUntilExit];
}
