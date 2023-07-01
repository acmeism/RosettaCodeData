@implementation MyClass

// Was not declared because init is defined in NSObject
- (instancetype)init
{
    if (self = [super init]) {
        variable = 0; // not strictly necessary as all instance variables are initialized to zero
    }
    return self;
}

- (int)variable
{
    return variable;
}

@end
