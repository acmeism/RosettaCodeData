import std.range, std.algorithm;

struct Permutations(bool doCopy=true, T) {
    T[] items;
    int r;
    bool stopped;
    int[] indices, cycles;
    static if (!doCopy)
        T[] result;

    this(T)(T[] items, int r=-1) pure nothrow @safe {
        this.items = items;
        immutable int n = items.length;
        if (r < 0)
            r = n;
        this.r = r;
        immutable n_minus_r = n - r;
        if (n_minus_r < 0) {
            this.stopped = true;
        } else {
            this.stopped = false;
            this.indices = n.iota.array;
            //this.cycles = iota(n, n_minus_r, -1).array; // Not nothrow.
            this.cycles = iota(n_minus_r + 1, n + 1).retro.array;
        }

        static if (!doCopy)
            result = new T[r];
    }

    @property bool empty() const pure nothrow @safe @nogc {
        return this.stopped;
    }

    static if (doCopy) {
        @property T[] front() const pure nothrow @safe {
            assert(!this.stopped);
            auto result = new T[r];
            foreach (immutable i, ref re; result)
                re = items[indices[i]];
            return result;
        }
    } else {
        @property T[] front() pure nothrow @safe @nogc {
            assert(!this.stopped);
            foreach (immutable i, ref re; this.result)
                re = items[indices[i]];
            return this.result;
        }
    }

    void popFront() pure nothrow /*@safe*/ @nogc {
        assert(!this.stopped);
        int i = r - 1;
        while (i >= 0) {
            immutable int j = cycles[i] - 1;
            if (j > 0) {
                cycles[i] = j;
                indices[i].swap(indices[$ - j]);
                return;
            }
            cycles[i] = indices.length - i;
            immutable int n1 = indices.length - 1;
            assert(n1 >= 0);
            immutable int num = indices[i];

            // copy isn't @safe.
            indices[i + 1 .. n1 + 1].copy(indices[i .. n1]);
            indices[n1] = num;
            i--;
        }

        this.stopped = true;
    }
}

Permutations!(doCopy, T) permutations(bool doCopy=true, T)
                                     (T[] items, int r=-1)
pure nothrow @safe {
    return Permutations!(doCopy, T)(items, r);
}

// ---------------------------------

import std.stdio, std.typecons, std.conv, std.algorithm, std.array,
       std.exception, std.string;

enum maxIters = 1_000_000;

string A036058(in string ns) pure nothrow @safe {
    return ns.representation.group.map!(t => t[1].text ~ char(t[0])).join;
}

int A036058_length(bool doPrint=false)(string numberString="0") {
    int iterations = 1;
    int queueIndex;
    string[3] lastThree;

    while (true) {
        static if (doPrint)
            writefln("  %2d %s", iterations, numberString);

        numberString = numberString
                       .dup
                       .representation
                       .sort()
                       .release
                       .assumeUTF;

        if (lastThree[].canFind(numberString))
            break;
        assert(iterations < maxIters);
        lastThree[queueIndex] = numberString;
        numberString = numberString.A036058;
        iterations++;
        queueIndex++;
        queueIndex %= 3;
    }

    return iterations;
}

Tuple!(int,int[]) max_A036058_length(R)(R startRange = 11.iota) {
    bool[string] alreadyDone;
    auto max_len = tuple(-1, (int[]).init);

    foreach (n; startRange) {
        immutable sns = n
                        .to!(char[])
                        .representation
                        .sort()
                        .release
                        .assumeUTF;

        if (sns !in alreadyDone) {
            alreadyDone[sns] = true;
            const size = sns.A036058_length;
            if (size > max_len[0])
                max_len = tuple(size, [n]);
            else if (size == max_len[0])
                max_len[1] ~= n;
        }
    }
    return max_len;
}

void main() {
    //const (lenMax, starts) = maxIters.iota.max_A036058_length;
    const lenMax_starts = maxIters.iota.max_A036058_length;
    immutable lenMax = lenMax_starts[0];
    const starts = lenMax_starts[1];

    // Expand:
    int[] allStarts;
    foreach (immutable n; starts) {
        bool[string] set;
        foreach (const k; permutations!false(n.to!(char[]), 4))
            if (k[0] != '0')
                set[k.idup] = true;
        //allStarts ~= set.byKey.to!(int[]);
        allStarts ~= set.byKey.map!(to!int).array;
    }

    allStarts = allStarts.sort().filter!(x => x < maxIters).array;

    writefln("The longest length, followed by the number(s) with the
longest sequence length for starting sequence numbers below maxIters
are:
Iterations = %d and sequence-starts = %s.", lenMax, allStarts);

    writeln("Note that only the first of any sequences with the same
digits is printed below. (The others will differ only in their first
term).");

    foreach (immutable n; starts) {
        writeln;
        A036058_length!true(n.text);
    }
}
