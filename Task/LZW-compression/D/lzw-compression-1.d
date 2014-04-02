import std.stdio, std.array;

auto compress(in string original) pure nothrow {
    int[string] dict;
    foreach (immutable char c; char.min .. char.max + 1)
        dict[[c]] = c;

    string w;
    int[] result;
    foreach (immutable ch; original)
        if (w ~ ch in dict)
            w = w ~ ch;
        else {
            result ~= dict[w];
            dict[w ~ ch] = dict.length;
            w = [ch];
        }
    return w.empty ? result : (result ~ dict[w]);
}

auto decompress(in int[] compressed) pure nothrow {
    auto dict = new string[char.max - char.min + 1];
    foreach (immutable char c; char.min .. char.max + 1)
        dict[c] = [c];

    auto w = dict[compressed[0]];
    auto result = w;
    foreach (immutable k; compressed[1 .. $]) {
        auto entry = (k < dict.length) ? dict[k] : w ~ w[0];
        result ~= entry;
        dict ~= w ~ entry[0];
        w = entry;
    }
    return result;
}

void main() {
    auto comp = "TOBEORNOTTOBEORTOBEORNOT".compress;
    writeln(comp, "\n", comp.decompress);
}
