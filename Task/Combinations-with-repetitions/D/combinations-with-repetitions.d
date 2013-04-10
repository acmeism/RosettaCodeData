import std.stdio, std.range;

const struct CombRep {
    immutable uint nt, nc;
    private immutable ulong[] combVal;

    this(in uint numType, in uint numChoice) pure nothrow
    in {
        assert(0 < numType && numType + numChoice <= 64,
               "Valid only for nt + nc <= 64 (ulong bit size)");
    } body {
        nt = numType;
        nc = numChoice;
        if (nc == 0)
            return;
        ulong v  = (1UL << (nt - 1)) - 1;

        // Init to smallest number that has nt-1 bit set
        // a set bit is metaphored as a _type_ seperator.
        immutable limit = v << nc;

        // Limit is the largest nt-1 bit set number that has nc
        // zero-bit a zero-bit means a _choice_ between _type_
        // seperators.
        while (v <= limit) {
            combVal ~= v;
            if (v == 0)
                break;
            // Get next nt-1 bit number.
            immutable t = (v | (v - 1)) + 1;
            v = t | ((((t & -t) / (v & -v)) >> 1) - 1);
        }
    }

    uint length() @property const pure nothrow {
        return combVal.length;
    }

    uint[] opIndex(in uint idx) const pure nothrow {
        return val2set(combVal[idx]);
    }

    int opApply(immutable int delegate(in ref uint[]) dg) {
        foreach (immutable v; combVal) {
            auto set = val2set(v);
            if (dg(set))
                break;
        }
        return 1;
    }

    private uint[] val2set(in ulong v) const pure nothrow {
        // Convert bit pattern to selection set
        immutable uint bitLimit = nt + nc - 1;
        uint typeIdx = 0;
        uint[] set;
        foreach (immutable bitNum; 0 .. bitLimit)
            if (v & (1 << (bitLimit - bitNum - 1)))
                typeIdx++;
            else
                set ~= typeIdx;
        return set;
    }
}

// For finite Random Access Range.
auto combRep(R)(R types, in uint numChoice) /*pure nothrow*/
if (hasLength!R && isRandomAccessRange!R) {
    ElementType!R[][] result;

    foreach (const s; CombRep(types.length, numChoice)) {
        ElementType!R[] r;
        foreach (immutable i; s)
            r ~= types[i];
        result ~= r;
    }

    return result;
}

void main() {
    foreach (const e; combRep(["iced", "jam", "plain"], 2))
        writefln("%-(%5s %)", e);
    writeln("Ways to select 3 from 10 types is ",
            CombRep(10, 3).length);
}
