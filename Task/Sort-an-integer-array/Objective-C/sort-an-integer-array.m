- (void)example
{
    NSArray *nums, *sorted;
    nums = [NSArray arrayWithObjects:
        [NSNumber numberWithInt:2],
        [NSNumber numberWithInt:4],
        [NSNumber numberWithInt:3],
        [NSNumber numberWithInt:1],
        [NSNumber numberWithInt:2],
        nil];
    sorted = [nums sortedArrayUsingSelector:@selector(compare:)];
}
