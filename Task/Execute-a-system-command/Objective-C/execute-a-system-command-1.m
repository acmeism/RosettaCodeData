void runls()
{
    [[NSTask launchedTaskWithLaunchPath:@"/bin/ls"
        arguments:@[]] waitUntilExit];
}
