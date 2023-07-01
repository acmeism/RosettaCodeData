import std.stdio, std.ascii, std.algorithm, core.memory, permutations2;

/** Uses greedy algorithm of adding another char (or two, or three, ...)
until an unseen perm is formed in the last n chars. */
string superpermutation(in uint n) nothrow
in {
    assert(n > 0 && n < uppercase.length);
} out(result) {
    // It's a superpermutation.
    assert(uppercase[0 .. n].dup.permutations.all!(p => result.canFind(p)));
} body {
    string result = uppercase[0 .. n];

    bool[const char[]] toFind;
    GC.disable;
    foreach (const perm; result.dup.permutations)
        toFind[perm] = true;
    GC.enable;
    toFind.remove(result);

    auto trialPerm = new char[n];
    auto auxAdd = new char[n];

    while (toFind.length) {
        MIDDLE: foreach (immutable skip; 1 .. n) {
            auxAdd[0 .. skip] = result[$ - n .. $ - n + skip];
            foreach (const trialAdd; auxAdd[0 .. skip].permutations!false) {
                trialPerm[0 .. n - skip] = result[$ + skip - n .. $];
                trialPerm[n - skip .. $] = trialAdd[];
                if (trialPerm in toFind) {
                    result ~= trialAdd;
                    toFind.remove(trialPerm);
                    break MIDDLE;
                }
            }
        }
    }

    return result;
}

void main() {
    foreach (immutable n; 1 .. 8)
        n.superpermutation.length.writeln;
}
