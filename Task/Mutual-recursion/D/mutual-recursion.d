import std.stdio, std.algorithm, std.range;

/*auto*/ int male(in int n) pure nothrow {
    return n ? (n - female(male(n - 1))) : 0;
}

/*auto*/ int female(in int n) pure nothrow {
    return n ? (n - male(female(n - 1))) : 1;
}

void main() {
    iota(20).map!female().writeln();
    iota(20).map!male().writeln();
}
