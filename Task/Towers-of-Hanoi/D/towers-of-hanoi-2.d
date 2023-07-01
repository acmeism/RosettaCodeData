// Code found and then improved by Glenn C. Rhoads,
// then some more by M. Kolar (2000).
void main(in string[] args) {
    import core.stdc.stdio, std.conv, std.typetuple;

    immutable size_t n = (args.length > 1) ? args[1].to!size_t : 3;
    size_t[3] p = [(1 << n) - 1, 0, 0];

    // Show the start configuration of the pegs.
    '|'.putchar;
    foreach_reverse (immutable i; 1 .. n + 1)
        printf(" %d", i);
    "\n|\n|".puts;

    foreach (immutable size_t x; 1 .. (1 << n)) {
        {
            immutable size_t i1 = x & (x - 1);
            immutable size_t fr = (i1 + i1 / 3) & 3;
            immutable size_t i2 = (x | (x - 1)) + 1;
            immutable size_t to = (i2 + i2 / 3) & 3;

            size_t j = 1;
            for (size_t w = x; !(w & 1); w >>= 1, j <<= 1) {}

            // Now j is not the number of the disk to move,
            // it contains the single bit to be moved:
            p[fr] &= ~j;
            p[to] |= j;
        }

        // Show the current configuration of pegs.
        foreach (immutable size_t k; TypeTuple!(0, 1, 2)) {
            "\n|".printf;
            size_t j = 1 << n;
            foreach_reverse (immutable size_t w; 1 .. n + 1) {
                j >>= 1;
                if (j & p[k])
                    printf(" %zd", w);
            }
        }
        '\n'.putchar;
    }
}
