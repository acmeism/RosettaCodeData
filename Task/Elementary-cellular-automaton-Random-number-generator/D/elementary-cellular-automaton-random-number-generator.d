import std.stdio, std.range, std.typecons;

struct CellularRNG {
    private uint current;
    private immutable uint rule;
    private ulong state;

    this(in ulong state_, in uint rule_) pure nothrow @safe @nogc {
        this.state = state_;
        this.rule = rule_;
        popFront;
    }

    public enum bool empty = false;
    @property uint front() pure nothrow @safe @nogc { return current; }

    void popFront() pure nothrow @safe @nogc {
        enum uint nBit = 8;
        enum uint NU = ulong.sizeof * nBit;
        current = 0;

        foreach_reverse (immutable i; 0 .. nBit) {
            immutable state2 = state;
            current |= (state2 & 1) << i;

            state = 0;
            /*static*/ foreach (immutable j; staticIota!(0, NU)) {
                // To avoid undefined behavior with out-of-range shifts.
                static if (j > 0)
                    immutable aux1 = state2 >> (j - 1);
                else
                    immutable aux1 = state2 >> 63;

                static if (j == 0)
                    immutable aux2 = state2 << 1;
                else static if (j == 1)
                    immutable aux2 = state2 << 63;
                else
                    immutable aux2 = state2 << (NU + 1 - j);

                immutable aux = 7 & (aux1 | aux2);
                if (rule & (1UL << aux))
                    state |= 1UL << j;
            }
        }
    }
}

void main() {
    CellularRNG(1, 30).take(10).writeln;
    CellularRNG(1, 30).drop(2_000_000).front.writeln;
}
