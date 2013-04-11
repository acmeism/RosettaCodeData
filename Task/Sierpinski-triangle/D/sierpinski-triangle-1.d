import std.stdio, std.algorithm, std.string, std.array;

void main() {
    enum level = 4;
    auto d = ["*"];
    foreach (n; 0 .. level) {
        const sp = " ".replicate(2 ^^ n);
        d = d.map!(a => sp ~ a ~ sp)().array() ~
            d.map!(a => a ~ " " ~ a)().array();
    }
    d.join("\n").writeln();
}
