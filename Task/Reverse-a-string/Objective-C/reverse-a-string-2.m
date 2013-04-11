int main()
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *test = [@"!A string to be reverted!" reverseString];

    NSLog(@"%@", test);

    [pool release];
    return 0;
}
