import std.range, std.algorithm;

struct Permutations(bool doCopy=true, T) {
    T[] items;
    int r;
    bool stopped;
    int[] indices, cycles;
    static if (!doCopy)
        T[] result;

    this(T)(T[] items, int r=-1) /*pure nothrow*/ {
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
            this.indices = iota(n).array(); // not pure nothrow
            this.cycles = iota(n, n_minus_r, -1).array();
        }

        static if (!doCopy)
            result = new T[r];
    }

    @property bool empty() const pure nothrow {
        return this.stopped;
    }

    static if (doCopy) {
        @property T[] front() const pure nothrow {
            assert(!this.stopped);
            auto result = new T[r];
            foreach (i, ref re; result)
                re = items[indices[i]];
            return result;
        }
    } else {
        @property T[] front() pure nothrow {
            assert(!this.stopped);
            foreach (i, ref re; this.result)
                re = items[indices[i]];
            return this.result;
        }
    }

    void popFront() pure nothrow {
        assert(!this.stopped);
        int i = r - 1;
        while (i >= 0) {
            immutable int j = cycles[i] - 1;
            if (j > 0) {
                cycles[i] = j;
                swap(indices[i], indices[$ - j]);
                return;
            }
            cycles[i] = indices.length - i;
            immutable int n1 = indices.length - 1;
            assert(n1 >= 0);
            immutable int num = indices[i];
            foreach (k; i .. n1)
                indices[k] = indices[k + 1];
            indices[n1] = num;
            i--;
        }

        this.stopped = true;
    }
}

Permutations!(doCopy, T) permutations(bool doCopy=true, T)
                                     (T[] items, int r=-1)
/*pure nothrow*/ {
    return Permutations!(doCopy, T)(items, r);
}

// ---------------------------------

import std.stdio, std.typecons, std.conv, std.algorithm, std.array;

enum maxIters = 1_000_000;

string A036058(string ns) {
    return group(ns).map!(t => text(t[1]) ~ cast(char)t[0])().join();
}

int A036058_length(bool doPrint=false)(string numberString="0") {
    int iterations = 1;
    int queue_index;
    string[3] last_three;

    while (true) {
        static if (doPrint)
            writefln("  %2d %s", iterations, numberString);

        //numberString = cast(string)(cast(ubyte[])numberString.dup).sort().release();
        // this is a workaround --------
        int[10] digitsCounts;
        foreach (char digit; numberString)
            digitsCounts[digit - '0']++;
        auto numb = new char[numberString.length];
        int count = 0;
        foreach (i, d; digitsCounts)
            foreach (n; 0 .. d) {
                numb[count] = cast(char)(i + '0');
                count++;
            }
        numberString = cast(string)numb;
        // end work-around --------

        if (last_three[].canFind(numberString))
            break;
        assert(iterations < maxIters);
        last_three[queue_index] = numberString;
        numberString = A036058(numberString);
        iterations++;
        queue_index++;
        queue_index %= 3;
    }

    return iterations;
}

Tuple!(int,int[]) max_A036058_length(R)(R start_range=iota(11)) {
    bool[string] already_done;
    auto max_len = tuple(-1, (int[]).init);

    foreach (n; start_range) {
        string sns = cast(string)(cast(ubyte[])to!(char[])(n)).sort().release();
        if (sns !in already_done) {
            already_done[sns] = true;
            int size = A036058_length(sns);
            if (size > max_len[0])
                max_len = tuple(size, [n]);
            else if (size == max_len[0])
                max_len[1] ~= n;
        }
    }
    return max_len;
}

void main() {
    auto lenMax_starts = max_A036058_length(iota(maxIters));
    int lenMax = lenMax_starts[0];
    int[] starts = lenMax_starts[1];

    // Expand
    int[] allStarts;
    foreach (n; starts) {
        bool[string] set;
        foreach (k; permutations!false(to!(char[])(n), 4))
            if (k[0] != '0')
                set[k.idup] = true;
        allStarts ~= set.byKey().map!(to!int)().array();
    }

    allStarts = allStarts.sort().release().filter!(x => x < maxIters)().array();

    writefln("The longest length, followed by the number(s) with the
longest sequence length for starting sequence numbers below maxIters
are:
Iterations = %d and sequence-starts = %s.", lenMax, allStarts);

    writeln("Note that only the first of any sequences with the same
digits is printed below. (The others will differ only in their first
term).");

    foreach (n; starts) {
        writeln();
        A036058_length!true(to!string(n));
    }
}
