auto powerSet(T)(T[] xs) pure nothrow @safe {
    static struct Result {
        T[] xsLocal, output;
        size_t len;
        size_t bits;

        this(T[] xs_) pure nothrow @safe {
            this.xsLocal = xs_;
            this.output.length = xs_.length;
            this.len = 1U << xs_.length;
        }

        @property empty() const pure nothrow @safe {
            return bits == len;
        }

        void popFront() pure nothrow @safe { bits++; }
        @property save() pure nothrow @safe { return this; }

        T[] front() pure nothrow @safe {
            size_t pos = 0;
            foreach (immutable size_t i; 0 .. xsLocal.length)
                if (bits & (1 << i))
                    output[pos++] = xsLocal[i];
            return output[0 .. pos];
        }
    }

    return Result(xs);
}

version (power_set2_main) {
    void main() {
        import std.stdio;
        [1, 2, 3].powerSet.writeln;
    }
}
