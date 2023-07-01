import std.traits;

enum isSubroutine(alias F) = is(ReturnType!F == void);

void main() {
    void foo1() {}

    // Calling a function that requires no arguments:
    foo1();
    foo1; // Alternative syntax.


    void foo2(int x, int y) {}

    immutable lambda = function int(int x) => x ^^ 2;

    // Calling a function with a fixed number of arguments:
    foo2(1, 2);
    foo2(1, 2);
    cast(void)lambda(1);


    void foo3(int x, int y=2) {}

    // Calling a function with optional arguments:
    foo3(1);
    foo3(1, 3);

    int sum(int[] arr...) {
        int tot = 0;
        foreach (immutable x; arr)
            tot += x;
        return tot;
    }

    real sum2(Args...)(Args arr) {
        typeof(return) tot = 0;
        foreach (immutable x; arr)
            tot += x;
        return tot;
    }

    // Calling a function with a variable number of arguments:
    assert(sum(1, 2, 3) == 6);
    assert(sum(1, 2, 3, 4) == 10);
    assert(sum2(1, 2.5, 3.5) == 7);

    // Calling a function with named arguments:
    // Various struct or tuple-based tricks can be used for this,
    // but currently D doesn't have named arguments.


    // Using a function in statement context (?):
    if (1)
        foo1;

    // Using a function in first-class context within an expression:
    assert(sum(1) == 1);


    auto foo4() { return 1; }

    // Obtaining the return value of a function:
    immutable x = foo4;


    // Distinguishing built-in functions and user-defined functions:
    // There are no built-in functions, beside the operators, and
    // pseudo-functions like assert().


    int myFynction(int x) { return x; }
    void mySubroutine(int x) {}

    // Distinguishing subroutines and functions:
    // (A subroutine is merely a function that has no explicit
    // return statement and will return void).
    pragma(msg, isSubroutine!mySubroutine); // Prints: true
    pragma(msg, isSubroutine!myFynction);   // Prints: false


    void foo5(int a, in int b, ref int c, out int d, lazy int e, scope int f) {}

    // Stating whether arguments are passed by value, by reference, etc:
    alias STC = ParameterStorageClass;
    alias psct = ParameterStorageClassTuple!foo5;
    static assert(psct.length == 6); // Six parameters.
    static assert(psct[0] == STC.none);
    static assert(psct[1] == STC.none);
    static assert(psct[2] == STC.ref_);
    static assert(psct[3] == STC.out_);
    static assert(psct[4] == STC.lazy_);
    static assert(psct[5] == STC.scope_);
    // There are also inout and auto ref.


    int foo6(int a, int b) { return a + b; }

    // Is partial application possible and how:
    import std.functional;
    alias foo6b = partial!(foo6, 5);
    assert(foo6b(6) == 11);
}
