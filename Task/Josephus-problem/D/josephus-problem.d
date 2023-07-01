import std.stdio, std.algorithm, std.array, std.string, std.range;

T pop(T)(ref T[] items, in size_t i) pure /*nothrow*/ @safe /*@nogc*/ {
    auto aux = items[i];
    items = items.remove(i);
    return aux;
}

string josephus(in int n, in int k) pure /*nothrow*/ @safe {
    auto p = n.iota.array;
    int i;
    immutable(int)[] seq;
    while (!p.empty) {
        i = (i + k - 1) % p.length;
        seq ~= p.pop(i);
    }

    return format("Prisoner killing order:\n%(%(%d %)\n%)." ~
                  "\nSurvivor: %d",
                  seq[0 .. $ - 1].chunks(20), seq[$ - 1]);
}

void main() /*@safe*/ {
    josephus(5, 2).writeln;
    writeln;
    josephus(41, 3).writeln;
}
