NSArray *arr1 = @[@1, @2, @3];
NSArray *arr2 = @[@4, @5, @6];
NSMutableArray *arr3 = [NSMutableArray arrayWithArray:arr1];
[arr3 addObjectsFromArray:arr2];
