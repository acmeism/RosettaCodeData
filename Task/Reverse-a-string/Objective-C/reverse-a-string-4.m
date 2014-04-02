int main()
{
    @autoreleasepool {

        NSString *test = [@"as⃝df̅" reverseString];

        NSLog(@"%@", test);

    }
    return 0;
}
