import std.stdio;

struct S {
    bool b;

    void foo() {}
    private void bar() {}
}

class C {
    bool b;

    void foo() {}
    private void bar() {}
}

void printProperties(T)() if (is(T == class) || is(T == struct)) {
    import std.stdio;
    import std.traits;

    writeln("Properties of ", T.stringof, ':');
    foreach (m; __traits(allMembers, T)) {
        static if (__traits(compiles, (typeof(__traits(getMember, T, m))))) {
            alias typeof(__traits(getMember, T, m)) ti;
            static if (!isFunction!ti) {
                writeln("    ", m);
            }
        }
    }
}

void main() {
    printProperties!S;
    printProperties!C;
}
