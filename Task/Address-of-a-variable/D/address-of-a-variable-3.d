void test(ref int i) {
    import std.stdio;
    writeln(&i);
}

void main() {
    test(* (cast(int*)0xdeadf00d) );
}
