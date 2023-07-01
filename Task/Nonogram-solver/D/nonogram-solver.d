import std.stdio, std.range, std.file, std.algorithm, std.string;

/// Create all patterns of a row or col that match given runs.
auto genRow(in int w, in int[] s) pure nothrow @safe {
    static int[][] genSeg(in int[][] o, in int sp) pure nothrow @safe {
        if (o.empty)
            return [[2].replicate(sp)];

        typeof(return) result;
        foreach (immutable x; 1 .. sp - o.length + 2)
            foreach (const tail; genSeg(o[1 .. $], sp - x))
                result ~= [2].replicate(x) ~ o[0] ~ tail;
        return result;
    }

    const ones = s.map!(i => [1].replicate(i)).array;
    return genSeg(ones, w + 1 - s.sum).map!dropOne;
}

/// Fix inevitable value of cells, and propagate.
void deduce(in int[][] hr, in int[][] vr) {
    static int[] allowable(in int[][] row) pure nothrow @safe {
        //return row.dropOne.fold!q{ a[] |= b[] }(row[0].dup);
        return reduce!q{ a[] |= b[] }(row[0].dup, row.dropOne);
    }

    static bool fits(in int[] a, in int[] b)
    pure /*nothrow*/ @safe /*@nogc*/ {
        return zip(a, b).all!(xy => xy[0] & xy[1]);
    }

    immutable int w = vr.length,
                  h = hr.length;
    auto rows = hr.map!(x => genRow(w, x).array).array;
    auto cols = vr.map!(x => genRow(h, x).array).array;
    auto canDo = rows.map!allowable.array;

    // Initially mark all columns for update.
    bool[uint] modRows, modCols;
    modCols = true.repeat.enumerate!uint.take(w).assocArray;

    /// See if any value a given column is fixed; if so,
    /// mark its corresponding row for future fixup.
    void fixCol(in int n) /*nothrow*/ @safe {
        const c = canDo.map!(x => x[n]).array;
        cols[n] = cols[n].remove!(x => !fits(x, c)); // Throws.
        foreach (immutable i, immutable x; allowable(cols[n]))
            if (x != canDo[i][n]) {
                modRows[i] = true;
                canDo[i][n] &= x;
            }
    }

    /// Ditto, for rows.
    void fixRow(in int n) /*nothrow*/ @safe {
        const c = canDo[n];
        rows[n] = rows[n].remove!(x => !fits(x, c)); // Throws.
        foreach (immutable i, immutable x; allowable(rows[n]))
            if (x != canDo[n][i]) {
                modCols[i] = true;
                canDo[n][i] &= x;
            }
    }

    void showGram(in int[][] m) {
        // If there's 'x', something is wrong.
        // If there's '?', needs more work.
        m.each!(x => writefln("%-(%c %)", x.map!(i => "x#.?"[i])));
        writeln;
    }

    while (modCols.length > 0) {
        modCols.byKey.each!fixCol;
        modCols = null;
        modRows.byKey.each!fixRow;
        modRows = null;
    }

    if (cartesianProduct(h.iota, w.iota)
        .all!(ij => canDo[ij[0]][ij[1]] == 1 || canDo[ij[0]][ij[1]] == 2))
        "Solution would be unique".writeln;
    else
        "Solution may not be unique, doing exhaustive search:".writeln;

    // We actually do exhaustive search anyway. Unique
    // solution takes no time in this phase anyway.
    auto out_ = new const(int)[][](h);

    uint tryAll(in int n = 0) {
        if (n >= h) {
            foreach (immutable j; 0 .. w)
                if (!cols[j].canFind(out_.map!(x => x[j]).array))
                    return 0;
            showGram(out_);
            return 1;
        }
        typeof(return) sol = 0;
        foreach (const x; rows[n]) {
            out_[n] = x;
            sol += tryAll(n + 1);
        }
        return sol;
    }

    immutable n = tryAll;
    switch (n) {
        case 0:  "No solution.".writeln;     break;
        case 1:  "Unique solution.".writeln; break;
        default: writeln(n, " solutions."); break;
    }
    writeln;
}

void solve(in string p, in bool showRuns=true) {
    immutable s = p.splitLines.map!(l => l.split.map!(w =>
                    w.map!(c => int(c - 'A' + 1)).array).array).array;
                    //w.map!(c => c - 'A' + 1))).to!(int[][][]);

    if (showRuns) {
        writeln("Horizontal runs: ", s[0]);
        writeln("Vertical runs: ", s[1]);
    }
    deduce(s[0], s[1]);
}

void main() {
    // Read problems from file.
    immutable fn = "nonogram_problems.txt";
    fn.readText.split("\n\n").filter!(p => !p.strip.empty).each!(p => p.strip.solve);

    "Extra example not solvable by deduction alone:".writeln;
    "B B A A\nB B A A".solve;

    "Extra example where there is no solution:".writeln;
    "B A A\nA A A".solve;
}
