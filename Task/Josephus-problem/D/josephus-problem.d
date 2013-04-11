import std.stdio, std.algorithm, std.array, std.string, std.range;

T pop(T)(ref T[] items, in size_t i) pure {
    auto aux = items[i];
    items.remove(i);
    items.length--;
    return aux;
}

string josephus(in int n, in int k) {
    auto p = iota(n).array();
    int i;
    int[] seq;
    while (!p.empty) {
        i = (i + k - 1) % p.length;
        seq ~= p.pop(i);
    }

    return xformat("Prisoner killing order: %(%d, %).\nSurvivor: %d",
                   seq[0 .. $-1], seq[$ - 1]);
}

void main() {
    writeln(josephus(5, 2));
    writeln();
    writeln(josephus(41, 3));
}
