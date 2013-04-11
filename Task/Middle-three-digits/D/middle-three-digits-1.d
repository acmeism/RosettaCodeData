import std.stdio, std.traits, std.conv;

string middleThreeDigits(T)(in T n) if (isIntegral!T) {
    auto s = n < 0 ? n.text()[1 .. $] : n.text();
    auto len = s.length;
    if (len < 3 || len % 2 == 0)
        return "Need odd and >= 3 digits";
    auto mid = len / 2;
    return s[mid - 1 .. mid + 2];
}

void main() {
    immutable passing = [123, 12345, 1234567, 987654321, 10001, -10001,
            -123, -100, 100, -12345, long.min, long.max];
    foreach (n; passing)
        writefln("middleThreeDigits(%s): %s", n, middleThreeDigits(n));

    immutable failing = [1, 2, -1, -10, 2002, -2002, 0,int.min,int.max];
    foreach (n; failing)
        writefln("middleThreeDigits(%s): %s", n, middleThreeDigits(n));
}
