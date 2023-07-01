void main(in string[] args) {
    import std.stdio, std.algorithm, std.math, std.file;

    auto data = sort(cast(ubyte[])args[0].read);
    return data
           .group
           .map!(g => g[1] / double(data.length))
           .map!(p => -p * p.log2)
           .sum
           .writeln;
}
