ulong nQueens(in uint nn) pure nothrow @nogc @safe
in {
    assert(nn > 0 && nn <= 27,
           "'side' value must be in 1 .. 27.");
} body {
    if (nn < 4)
        return nn == 1;

    enum uint ulen = uint.sizeof * 8;
    immutable uint full = uint.max - ((1 << (ulen - nn)) - 1);
    immutable n = nn - 3;

    typeof(return) count;
    uint[32] l=void, r=void, c=void;
    uint[33] mm; // mm and mmi are a stack.

    // Require second queen to be left of the first queen, so
    // we ever only test half of the possible solutions. This
    // is why we can't handle n=1 here.
    for (uint b0 = 1U << (ulen - n - 3); b0; b0 <<= 1) {
        for (uint b1 = b0 << 2; b1; b1 <<= 1) {
            uint d = n;
            // c: columns occupied by previous queens.
            c[n] = b0 | b1;
            // l: columns attacked by left diagonals.
            l[n] = (b0 << 2) | (b1 << 1);
            // r: by right diagnoals.
            r[n] = (b0 >> 2) | (b1 >> 1);

            // Availabe columns on current row.
            uint bits = full & ~(l[n] | r[n] | c[n]);

            uint mmi = 1;
            mm[mmi] = bits;

            while (bits) {
                // d: depth, aka row. counting backwards.
                // Because !d is often faster than d != n.
                while (d) {
                    // immutable uint pos = 1U << bits.bsf; // Slower.
                    immutable uint pos = -int(bits) & bits;

                    // Mark bit used. Only put current bits on
                    // stack if not zero, so backtracking will
                    // skip exhausted rows (because reading stack
                    // variable is slow compared to registers).
                    bits &= ~pos;
                    if (bits) {
                        mm[mmi] = bits | d;
                        mmi++;
                    }

                    d--;
                    l[d] = (l[d + 1] | pos) << 1;
                    r[d] = (r[d + 1] | pos) >> 1;
                    c[d] =  c[d + 1] | pos;

                    bits = full & ~(l[d] | r[d] | c[d]);

                    if (!bits)
                        break;
                    if (!d) {
                        count++;
                        break;
                    }
                }

                // Bottom of stack m is a zero'd field acting as
                // sentinel.  When saving to stack, left 27 bits
                // are the available columns, while right 5 bits
                // is the depth. Hence solution is limited to size
                // 27 board -- not that it matters in foreseeable
                // future.
                mmi--;
                bits = mm[mmi];
                d = bits & 31U;
                bits &= ~31U;
            }
        }
    }

    return count * 2;
}

void main(in string[] args) {
    import std.stdio, std.conv;

    immutable uint side = (args.length >= 2) ? args[1].to!uint : 8;
    writefln("N-queens(%d) = %d solutions.", side, side.nQueens);
}
