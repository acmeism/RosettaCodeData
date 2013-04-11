import std.stdio, std.regex, std.string, std.conv, std.range;

int[] rangeExpand(in string txt) /*pure nothrow*/ {
    typeof(return) result;

    foreach (r; std.string.split(txt, ",")) {
        const m = r.match(r"^(-?\d+)(-?(-?\d+))?$").captures.array;
        result ~= m[2].empty ? [m[1].to!int] :
                  iota(m[1].to!int, m[3].to!int + 1).array;
    }
    return result;
}

void main() {
    "-6,-3--1,3-5,7-11,14,15,17-20".rangeExpand.writeln;
}
