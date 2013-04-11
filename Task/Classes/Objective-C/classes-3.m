// Creating an instance
MyClass *mc = [[MyClass alloc] init];

// Sending a message
[mc variable];

// Releasing it. When its reference count goes to zero, it will be deallocated
[mc release];
