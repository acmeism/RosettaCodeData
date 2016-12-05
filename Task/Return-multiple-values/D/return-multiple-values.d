import std.stdio, std.typecons, std.algorithm;

auto addSub(T)(T x, T y) {
    return tuple(x + y, x - y);
}

alias _(T...) = T; // костыль

void main() {
    int a, b;
    _!(a, b) = addSub(33, 12); // _!(a, b) = [33, 12].fold!("a+b","a-b");

    writefln("33 + 12 = %d\n33 - 12 = %d", a, b);
}
