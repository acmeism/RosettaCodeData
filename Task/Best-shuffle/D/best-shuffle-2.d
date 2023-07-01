import std.stdio, std.algorithm, std.range;

extern(C) pure nothrow void* alloca(in size_t size);

void bestShuffle(in char[] txt, ref char[] result) pure nothrow {
    // Assume alloca to be pure.
    //extern(C) pure nothrow void* alloca(in size_t size);
    enum size_t NCHAR = size_t(char.max + 1);
    enum size_t MAX_VLA_SIZE = 1024;
    immutable size_t len = txt.length;
    if (len == 0)
        return;

    // txt and result must have the same length
    // allocate only when necessary
    if (result.length != len)
        result.length = len;

    // how many of each character?
    size_t[NCHAR] counts;
    size_t fmax = 0;
    foreach (immutable char c; txt) {
        counts[c]++;
        if (fmax < counts[c])
            fmax = counts[c];
    }
    assert(fmax > 0 && fmax <= len);

    // all character positions, grouped by character
    size_t[] ndx1;
    {
        size_t* ptr1;
        if ((len * size_t.sizeof) < MAX_VLA_SIZE)
            ptr1 = cast(size_t*)alloca(len * size_t.sizeof);
        // If alloca() has failed, or the memory needed is too much
        // large, then allocate from the heap.
        ndx1 = (ptr1 == null) ? new size_t[len] : ptr1[0 .. len];
    }
    {
        int pos = 0;
        foreach (immutable size_t ch; 0 .. NCHAR)
           if (counts[ch])
                foreach (j, char c; txt)
                    if (c == ch) {
                        ndx1[pos] = j;
                        pos++;
                    }
    }

    // regroup them for cycles
    size_t[] ndx2;
    {
        size_t* ptr2;
        if ((len * size_t.sizeof) < MAX_VLA_SIZE)
            ptr2 = cast(size_t*)alloca(len * size_t.sizeof);
        ndx2 = (ptr2 == null) ? new size_t[len] : ptr2[0 .. len];
    }
    {
        size_t n, m;
        foreach (immutable size_t i; 0 .. len) {
            ndx2[i] = ndx1[n];
            n += fmax;
            if (n >= len) {
                m++;
                n = m;
            }
        }
    }

    // How long can our cyclic groups be?
    immutable size_t grp = 1 + (len - 1) / fmax;

    // How many of them are full length?
    immutable size_t lng = 1 + (len - 1) % fmax;

    // Rotate each group.
    {
        size_t j;
        foreach (immutable size_t i; 0 .. fmax) {
            immutable size_t first = ndx2[j];
            immutable size_t glen = grp - (i < lng ? 0 : 1);
            foreach (immutable size_t k; 1 .. glen)
                ndx1[j + k - 1] = ndx2[j + k];
            ndx1[j + glen - 1] = first;
            j += glen;
        }
    }

    // Result is original permuted according to our cyclic groups.
    foreach (immutable size_t i; 0 .. len)
        result[ndx2[i]] = txt[ndx1[i]];
}

void main() {
    auto data = ["abracadabra", "seesaw", "elk", "grrrrrr",
                 "up", "a", "aabbbbaa", "", "xxxxx"];
    foreach (txt; data) {
        auto result = txt.dup;
        bestShuffle(txt, result);
        immutable nEqual = zip(txt, result).count!q{ a[0] == a[1] };
        writefln("%s, %s, (%d)", txt, result, nEqual);
    }
}
