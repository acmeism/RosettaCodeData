void main() {
    import std.stdio, std.range, std.algorithm, std.conv,
           std.string, std.regex;

    "Numbers please separated by space/commas: ".write;
    immutable numbers = readln
                        .strip
                        .splitter(r"[\s,]+".regex)
                        .array /**/
                        .to!(real[]);
    immutable mm = numbers.reduce!(min, max);
    writefln("min: %4f, max: %4f", mm[]);
    immutable bars = iota(9601, 9609).map!(i => i.to!dchar).dtext;
    immutable div = (mm[1] - mm[0]) / (bars.length - 1);
    numbers.map!(n => bars[cast(int)((n - mm[0]) / div)]).writeln;
}
