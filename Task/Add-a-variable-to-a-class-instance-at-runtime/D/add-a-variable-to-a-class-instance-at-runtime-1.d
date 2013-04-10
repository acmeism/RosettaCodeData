struct Dynamic(T) {
    private T[string] vars;

    @property T opDispatch(string key)() pure nothrow {
        return vars[key];
    }

    @property void opDispatch(string key, U)(U value)/*pure*/ nothrow {
        vars[key] = value;
    }
}

void main() {
    import std.variant, std.stdio;

    // If the type of the attributes is known at compile-time:
    auto d1 = Dynamic!double();
    d1.first = 10.5;
    d1.second = 20.2;
    writeln(d1.first, " ", d1.second);


    // If the type of the attributes is mixed:
    auto d2 = Dynamic!Variant();
    d2.a = "Hello";
    d2.b = 11;
    d2.c = ['x':2, 'y':4];
    d2.d = (int x) => x ^^ 3;
    writeln(d2.a, " ", d2.b, " ", d2.c);
    immutable int x = d2.b.get!int;
}
