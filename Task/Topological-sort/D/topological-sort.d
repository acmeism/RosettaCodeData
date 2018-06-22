import std.stdio, std.string, std.algorithm, std.range;

final class ArgumentException : Exception {
    this(string text) pure nothrow @safe /*@nogc*/ {
        super(text);
    }
}

alias TDependencies = string[][string];

string[][] topoSort(TDependencies d) pure /*nothrow @safe*/ {
    foreach (immutable k, v; d)
        d[k] = v.sort().uniq.filter!(s => s != k).array;
    foreach (immutable s; d.byValue.join.sort().uniq)
        if (s !in d)
            d[s] = [];

    string[][] sorted;
    while (true) {
        string[] ordered;

        foreach (immutable item, const dep; d)
            if (dep.empty)
                ordered ~= item;
        if (!ordered.empty)
            sorted ~= ordered.sort().release;
        else
            break;

        TDependencies dd;
        foreach (immutable item, const dep; d)
            if (!ordered.canFind(item))
                dd[item] = dep.dup.filter!(s => !ordered.canFind(s)).array;
        d = dd;
    }

    //if (!d.empty)
    if (d.length > 0)
        throw new ArgumentException(format(
            "A cyclic dependency exists amongst:\n%s", d));

    return sorted;
}

void main() {
    immutable data =
"des_system_lib std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee
dw01           ieee dw01 dware gtech
dw02           ieee dw02 dware
dw03           std synopsys dware dw03 dw02 dw01 ieee gtech
dw04           dw04 ieee dw01 dware gtech
dw05           dw05 ieee dware
dw06           dw06 ieee dware
dw07           ieee dware
dware          ieee dware
gtech          ieee gtech
ramlib         std ieee
std_cell_lib   ieee std_cell_lib
synopsys";

    TDependencies deps;
    foreach (immutable line; data.splitLines)
        deps[line.split[0]] = line.split[1 .. $];

    auto depw = deps.dup;
    foreach (immutable idx, const subOrder; depw.topoSort)
        writefln("#%d : %s", idx + 1,  subOrder);

    writeln;
    depw = deps.dup;
    depw["dw01"] ~= "dw04";
    foreach (const subOrder; depw.topoSort) // Should throw.
        subOrder.writeln;
}
