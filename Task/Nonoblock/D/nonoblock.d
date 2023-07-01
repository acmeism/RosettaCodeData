import std.stdio, std.array, std.algorithm, std.exception, std.conv,
       std.concurrency, std.range;

struct Solution { uint pos, len; }

Generator!(Solution[]) nonoBlocks(in uint[] blocks, in uint cells) {
    return new typeof(return)({
        if (blocks.empty || blocks[0] == 0) {
            yield([Solution(0, 0)]);
        } else {
            enforce(blocks.sum + blocks.length - 1 <= cells,
                    "Those blocks cannot fit in those cells.");
            immutable firstBl = blocks[0];
            const restBl = blocks.dropOne;

            // The other blocks need space.
            immutable minS = restBl.map!(b => b + 1).sum;

            // Slide the start position from left to max RH
            // index allowing for other blocks.
            foreach (immutable bPos; 0 .. cells - minS - firstBl + 1) {
                if (restBl.empty) {
                    // No other blocks to the right so just yield
                    // this one.
                    yield([Solution(bPos, firstBl)]);
                } else {
                    // More blocks to the right so create a sub-problem
                    // of placing the restBl blocks in the cells one
                    // space to the right of the RHS of this block.
                    immutable offset = bPos + firstBl + 1;
                    immutable newCells = cells - offset;

                    // Recursive call to nonoBlocks yields multiple
                    // sub-positions.
                    foreach (const subPos; nonoBlocks(restBl, newCells)) {
                        // Remove the offset from sub block positions.
                        auto rest = subPos.map!(sol => Solution(offset + sol.pos, sol.len));

                        // Yield this block plus sub blocks positions.
                        yield(Solution(bPos, firstBl) ~ rest.array);
                    }
                }
            }
        }
    });
}


/// Pretty prints each run of blocks with a
/// different letter for each block of filled cells.
string show(in Solution[] vec, in uint nCells) pure {
    auto result = ['_'].replicate(nCells);
    foreach (immutable i, immutable sol; vec)
        foreach (immutable j; sol.pos .. sol.pos + sol.len)
            result[j] = (result[j] == '_') ? to!char('A' + i) : '?';
    return '[' ~ result ~ ']';
}

void main() {
    static struct Problem { uint[] blocks; uint nCells; }

    immutable Problem[] problems = [{[2, 1], 5},
                                    {[], 5},
                                    {[8], 10},
                                    {[2, 3, 2, 3], 15},
                                    {[4, 3], 10},
                                    {[2, 1], 5},
                                    {[3, 1], 10},
                                    {[2, 3], 5}];

    foreach (immutable prob; problems) {
        writefln("Configuration (%d cells and %s blocks):",
                 prob.nCells, prob.blocks);
        show([], prob.nCells).writeln;
        "Possibilities:".writeln;
        auto nConfigs = 0;
        foreach (const sol; nonoBlocks(prob.tupleof)) {
            show(sol, prob.nCells).writeln;
            nConfigs++;
        }
        writefln("A total of %d possible configurations.", nConfigs);
        writeln;
    }
}
