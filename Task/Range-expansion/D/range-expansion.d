import std.stdio, std.regex, std.string, std.conv, std.range,
       std.algorithm;

int[] rangeExpand(in string txt) /*pure nothrow*/ {
    return txt.split(",").map!((r) {
        const m = r.match(r"^(-?\d+)(-?(-?\d+))?$").captures.array;
        return m[2].empty ? [m[1].to!int] :
                            iota(m[1].to!int, m[3].to!int + 1).array;
    }).join.array;
}

void main() {
    "-6,-3--1,3-5,7-11,14,15,17-20".rangeExpand.writeln;
}
