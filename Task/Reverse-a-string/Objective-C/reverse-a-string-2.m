int main()
{
    @autoreleasepool {

        NSString *test = [@"!A string to be reverted!" reverseString];

        NSLog(@"%@", test);

    }
    return 0;
}
