import std.algorithm, std.conv, std.traits;

struct Permutations(bool doCopy=true, T) if (isMutable!T) {
    private immutable size_t num;
    private T[] items;
    private uint[31] indexes;
    private ulong tot;

    this (T[] items) pure nothrow @safe @nogc
    in {
        static enum string L = indexes.length.text;
        assert(items.length >= 0 && items.length <= indexes.length,
               "Permutations: items.length must be >= 0 && < " ~ L);
    } body {
        static ulong factorial(in size_t n) pure nothrow @safe @nogc {
            ulong result = 1;
            foreach (immutable i; 2 .. n + 1)
                result *= i;
            return result;
        }

        this.num = items.length;
        this.items = items;
        foreach (immutable i; 0 .. cast(typeof(indexes[0]))this.num)
            this.indexes[i] = i;
        this.tot = factorial(this.num);
    }

    @property T[] front() pure nothrow @safe {
        static if (doCopy) {
            return items.dup;
        } else
            return items;
    }

    @property bool empty() const pure nothrow @safe @nogc {
        return tot == 0;
    }

    @property size_t length() const pure nothrow @safe @nogc {
        // Not cached to keep the function pure.
        typeof(return) result = 1;
        foreach (immutable x; 1 .. items.length + 1)
            result *= x;
        return result;
    }

    void popFront() pure nothrow @safe @nogc {
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
                                    (T[] items)
pure nothrow if (isMutable!T) {
    return Permutations!(doCopy, T)(items);
}

version (permutations2_main) {
    void main() {
        import std.stdio, std.bigint;
        alias B = BigInt;
        foreach (p; [B(1), B(2), B(3)].permutations)
            assert((p[0] + 1) > 0);
        [1, 2, 3].permutations!false.writeln;
        [B(1), B(2), B(3)].permutations!false.writeln;
    }
}
