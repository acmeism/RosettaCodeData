import std.traits;
auto safeAdd(T)(T a, T b)
if (isFloatingPoint!T) {
    import std.math;     // nexDown, nextUp
    import std.typecons; // tuple
    return tuple!("d", "u")(nextDown(a+b), nextUp(a+b));
}

import std.stdio;
void main() {
    auto a = 1.2;
    auto b = 0.03;

    auto r = safeAdd(a, b);
    writefln("(%s + %s) is in the range %0.16f .. %0.16f", a, b, r.d, r.u);
}
