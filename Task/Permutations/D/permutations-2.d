import std.algorithm, std.conv, std.traits;

struct Permutations(bool doCopy=true, T) if (isMutable!T) {
    private immutable size_t num;
    private T[] items;
    private uint[31] indexes;
    private ulong tot;

    this (/*in*/ T[] items) /*pure nothrow*/
    in {
        static enum string L = text(indexes.length); // impure
        assert(items.length >= 0 && items.length <= indexes.length,
               "Permutations: items.length must be >= 0 && < " ~ L);
    } body {
        static ulong factorial(in uint n) pure nothrow {
            ulong result = 1;
            foreach (i; 2 .. n + 1)
                result *= i;
            return result;
        }

        this.num = items.length;
        this.items = items.dup;
        foreach (i; 0 .. cast(typeof(indexes[0]))this.num)
            this.indexes[i] = i;
        this.tot = factorial(this.num);
    }

    @property T[] front() pure nothrow {
        static if (doCopy) {
            //return items.dup; // Not nothrow.
            auto items2 = new T[items.length];
            items2[] = items[];
            return items2;
        } else
            return items;
    }

    @property bool empty() const pure nothrow {
        return tot == 0;
    }

    void popFront() pure nothrow {
        tot--;
        if (tot > 0) {
            size_t j = num - 2;

            while (indexes[j] > indexes[j + 1])
                j--;
            size_t k = num - 1;
            while (indexes[j] > indexes[k])
                k--;
            swap(indexes[k], indexes[j]);
            swap(items[k], items[j]);

            size_t r = num - 1;
            size_t s = j + 1;
            while (r > s) {
                swap(indexes[s], indexes[r]);
                swap(items[s], items[r]);
                r--;
                s++;
            }
        }
    }
}

Permutations!(doCopy,T) permutations(bool doCopy=true, T)
                                    (/*in*/ T[] items)
/*pure nothrow*/ if (isMutable!T) {
    return Permutations!(doCopy, T)(items);
} unittest {
    import std.bigint;
    foreach (p; permutations([BigInt(1), BigInt(2), BigInt(3)]))
        assert((p[0] + 1) > 0);
}

version (permutations2_main) {
    void main() {
        import std.stdio, std.bigint;
        foreach (p; permutations!false([1, 2, 3]))
            writeln(p);
        alias BigInt B;
        foreach (p; permutations!false([B(1), B(2), B(3)])) {}
    }
}
