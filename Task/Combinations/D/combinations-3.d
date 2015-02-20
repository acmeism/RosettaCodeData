module combinations3;

import std.traits: Unqual;

struct Combinations(T, bool copy=true) {
    Unqual!T[] pool, front;
    size_t r, n;
    bool empty = false;
    size_t[] indices;
    size_t len;
    bool lenComputed = false;

    this(T[] pool_, in size_t r_) pure nothrow @safe {
        this.pool = pool_.dup;
        this.r = r_;
        this.n = pool.length;
        if (r > n)
            empty = true;
        indices.length = r;
        foreach (immutable i, ref ini; indices)
            ini = i;
        front.length = r;
        foreach (immutable i, immutable idx; indices)
            front[i] = pool[idx];
    }

    @property size_t length() /*logic_const*/ pure nothrow @nogc {
        static size_t binomial(size_t n, size_t k) pure nothrow @safe @nogc
        in {
            assert(n > 0, "binomial: n must be > 0.");
        } body {
            if (k < 0 || k > n)
                return 0;
            if (k > (n / 2))
                k = n - k;
            size_t result = 1;
            foreach (size_t d; 1 .. k + 1) {
                result *= n;
                n--;
                result /= d;
            }
            return result;
        }

        if (!lenComputed) {
            // Set cache.
            len = binomial(n, r);
            lenComputed = true;
        }
        return len;
    }

    void popFront() pure nothrow @safe {
        if (!empty) {
            bool broken = false;
            size_t pos = 0;
            foreach_reverse (immutable i; 0 .. r) {
                pos = i;
                if (indices[i] != i + n - r) {
                    broken = true;
                    break;
                }
            }
            if (!broken) {
                empty = true;
                return;
            }
            indices[pos]++;
            foreach (immutable j; pos + 1 .. r)
                indices[j] = indices[j - 1] + 1;
            static if (copy)
                front = new Unqual!T[front.length];
            foreach (immutable i, immutable idx; indices)
                front[i] = pool[idx];
        }
    }
}

Combinations!(T, copy) combinations(bool copy=true, T)
                                   (T[] items, in size_t k)
in {
    assert(items.length, "combinations: items can't be empty.");
} body {
    return typeof(return)(items, k);
}

// Compile with -version=combinations3_main to run main.
version(combinations3_main)
void main() {
    import std.stdio, std.array, std.algorithm;
    [1, 2, 3, 4].combinations!false(2).array.writeln;
    [1, 2, 3, 4].combinations!true(2).array.writeln;
    [1, 2, 3, 4].combinations(2).map!(x => x).writeln;
}
