import std.stdio, std.range;

const struct CombRep {
    immutable uint nt, nc;
    private const ulong[] combVal;

    this(in uint numType, in uint numChoice) pure nothrow @safe
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

        ulong[] localCombVal;
        // Limit is the largest nt-1 bit set number that has nc
        // zero-bit a zero-bit means a _choice_ between _type_
        // seperators.
        while (v <= limit) {
            localCombVal ~= v;
            if (v == 0)
                break;
            // Get next nt-1 bit number.
            immutable t = (v | (v - 1)) + 1;
            v = t | ((((t & -t) / (v & -v)) >> 1) - 1);
        }
        this.combVal = localCombVal;
    }

    uint length() @property const pure nothrow @safe {
        return combVal.length;
    }

    uint[] opIndex(in uint idx) const pure nothrow @safe {
        return val2set(combVal[idx]);
    }

    int opApply(immutable int delegate(in ref uint[]) pure nothrow @safe dg)
    pure nothrow @safe {
        foreach (immutable v; combVal) {
            auto set = val2set(v);
            if (dg(set))
                break;
        }
        return 1;
    }

    private uint[] val2set(in ulong v) const pure nothrow @safe {
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
auto combRep(R)(R types, in uint numChoice) /*pure*/ nothrow @safe
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

void main() @safe {
    foreach (const e; combRep(["iced", "jam", "plain"], 2))
        writefln("%-(%5s %)", e);
    writeln("Ways to select 3 from 10 types is ",
            CombRep(10, 3).length);
}
