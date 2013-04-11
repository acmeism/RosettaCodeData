void runls()
{
    [[NSTask launchedTaskWithLaunchPath:@"/bin/ls"
        arguments:[NSArray array]] waitUntilExit];
}
