// There are no class variables, so static variables are used.
static int myClassVariable = 0;

@interface MyClass : NSObject
{
    int variable; // instance variable
}

- (int)variable; // Typical accessor - you should use the same name as the variable

@end
