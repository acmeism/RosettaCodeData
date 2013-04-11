void runSystemCommand(NSString *cmd)
{
    [[NSTask launchedTaskWithLaunchPath:@"/bin/sh"
        arguments:[NSArray arrayWithObjects:@"-c", cmd, nil]]
        waitUntilExit];
}
