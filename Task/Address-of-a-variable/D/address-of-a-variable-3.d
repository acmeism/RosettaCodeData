void test(ref int i) {
    writefln(&i);
}

void main() {
    test(* (cast(int*)0xdeadf00d) );
}
