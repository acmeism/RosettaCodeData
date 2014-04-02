int main()
{
  @autoreleasepool {
    NSArray *collection = @[@1, @2, @10, @5, @10.5];

    NSLog(@"%@", [collection maximumValue]);
  }
  return 0;
}
