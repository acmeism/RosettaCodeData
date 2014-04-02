@implementation MyClass

// Was not declared because init is defined in NSObject
- (id)init
{
    if (self = [super init])
        variable = 0;
    return self;
}

- (int)variable
{
    return variable;
}

@end
