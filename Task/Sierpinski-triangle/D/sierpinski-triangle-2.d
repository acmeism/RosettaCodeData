import std.string;

string sierpinski(int n) {
    auto parts = ["*"];
    auto space = " ";
    foreach (i; 0 .. n) {
        string[] parts2;
        foreach (x; parts)
            parts2 ~= space ~ x ~ space;
        foreach (x; parts)
            parts2 ~= x ~ " " ~ x;
        parts = parts2;
        space ~= space;
    }
    return parts.join("\n");
}

pragma(msg, sierpinski(4));
void main() {}
