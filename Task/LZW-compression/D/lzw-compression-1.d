import std.stdio, std.array;

auto compress(string original) {
    int[string] dict;
    foreach (b; 0 .. 256)
        dict[[cast(immutable char)b]] = b;

    string w;
    int[] result;
    foreach (ch; original)
        if (w ~ ch in dict)
            w = w ~ ch;
        else {
            result ~= dict[w];
            dict[w ~ ch] = dict.length - 1;
            w = [ch];
        }
    return w.empty ? result : (result ~ dict[w]);
}

auto decompress(int[] compressed) {
    auto dict = new string[256];
    foreach (b; 0 .. 256)
        dict[b] = [cast(char)b];

    auto w = dict[compressed[0]];
    auto result = w;
    foreach (k; compressed[1 .. $]) {
        auto entry = (k < dict.length) ? dict[k] : w ~ w[0];
        result ~= entry;
        dict ~= w ~ entry[0];
        w = entry;
    }
    return result;
}

void main() {
    auto comp = compress("TOBEORNOTTOBEORTOBEORNOT");
    writeln(comp, "\n", decompress(comp));
}
