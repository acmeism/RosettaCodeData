template registerable() {
    void register() { /* implementation */ }
}

string makeFunction(string s) {
    return `string `~s~`(){ return "`~s~`";}`;
}

class Foo {
    mixin registerable!();
    mixin(makeFunction("myFunction"));
}

unittest {
    import std.stdio : writeln;
    Foo foo = new Foo;
    foo.register();
    writeln(foo.myFunction());
}
