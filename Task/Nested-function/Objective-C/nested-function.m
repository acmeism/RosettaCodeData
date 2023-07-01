NSString *makeList(NSString *separator) {
  __block int counter = 1;

  NSString *(^makeItem)(NSString *) = ^(NSString *item) {
    return [NSString stringWithFormat:@"%d%@%@\n", counter++, separator, item];
  };

  return [NSString stringWithFormat:@"%@%@%@", makeItem(@"first"), makeItem(@"second"), makeItem(@"third")];
}

int main() {
  NSLog(@"%@", makeList(@". "));
  return 0;
}
