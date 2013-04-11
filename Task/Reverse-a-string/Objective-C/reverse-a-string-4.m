int main()
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *test = [@"as⃝df̅" reverseString];

    NSLog(@"%@", test);

    [pool release];
    return 0;
}
