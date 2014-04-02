auto powerSet(T)(T[] xs) pure nothrow {
    auto output = new T[xs.length];
    immutable size_t len = 1U << xs.length;

    struct Result {
        size_t bits;
        @property empty() const pure nothrow { return bits == len; }
        void popFront() pure nothrow { bits++; }
        @property save() pure nothrow { return this; }

        T[] front() nothrow {
            size_t pos = 0;
            foreach (immutable size_t i; 0 .. xs.length)
                if (bits & (1 << i))
                    output[pos++] = xs[i];
            return output[0 .. pos];
        }
    }

    return Result();
}

version (power_set2_main) {
    void main() {
        import std.stdio;
        [1, 2, 3].powerSet.writeln;
    }
}
