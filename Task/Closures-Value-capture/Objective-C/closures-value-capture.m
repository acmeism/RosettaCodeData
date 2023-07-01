NSMutableArray *funcs = [[NSMutableArray alloc] init];
for (int i = 0; i < 10; i++) {
  [funcs addObject:[^ { return i * i; } copy]];
}

int (^foo)(void) = funcs[3];
NSLog(@"%d", foo()); // logs "9"
