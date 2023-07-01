import std.stdio, std.range, std.algorithm;

T[][] combsRep(T)(T[] lst, in int k) {
    if (k == 0)
        return [[]];
    if (lst.empty)
        return null;

    return combsRep(lst, k - 1).map!(L => lst[0] ~ L).array
           ~ combsRep(lst[1 .. $], k);
}

void main() {
    ["iced", "jam", "plain"].combsRep(2).writeln;
    10.iota.array.combsRep(3).length.writeln;
}
