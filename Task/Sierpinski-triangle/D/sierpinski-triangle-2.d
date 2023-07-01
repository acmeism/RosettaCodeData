import std.string, std.range, std.algorithm;

string sierpinski(int level) pure nothrow /*@safe*/ {
    auto d = ["*"];
    foreach (immutable i; 0 .. level) {
        immutable sp = " ".replicate(2 ^^ i);
        d = d.map!(a => sp ~ a ~ sp).array ~
            d.map!(a => a ~ " " ~ a).array;
    }
    return d.join('\n');
}

pragma(msg, 4.sierpinski);
void main() {}
