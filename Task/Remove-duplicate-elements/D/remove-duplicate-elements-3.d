void main()
{
    import std.stdio, std.algorithm, std.array;

    auto a = [5,4,32,7,6,4,2,6,0,8,6,9].sort.uniq.array;
    a.writeln;
}
