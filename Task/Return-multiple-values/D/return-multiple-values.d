import std.stdio, std.typecons, std.algorithm;


mixin template ret(string z) {
    mixin({
        string res;

        auto r = z.split(" = ");
        auto m = r[0].split(", ");
        auto s = m.join("_");

        res ~= "auto " ~ s ~ " = " ~ r[1] ~ ";";
        foreach(i, n; m){
            res ~= "auto " ~ n ~ " = " ~ s ~ "[" ~ i.to!string ~ "];\n";
        }
        return res;
    }());
}

auto addSub(T)(T x, T y) {
    return tuple(x + y, x - y);
}

void main() {
    mixin ret!q{ a, b = addSub(33, 12) };

    writefln("33 + 12 = %d\n33 - 12 = %d", a, b);
}
