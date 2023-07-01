from itertools import izip

def gen_row(w, s):
    """Create all patterns of a row or col that match given runs."""
    def gen_seg(o, sp):
        if not o:
            return [[2] * sp]
        return [[2] * x + o[0] + tail
                for x in xrange(1, sp - len(o) + 2)
                for tail in gen_seg(o[1:], sp - x)]

    return [x[1:] for x in gen_seg([[1] * i for i in s], w + 1 - sum(s))]


def deduce(hr, vr):
    """Fix inevitable value of cells, and propagate."""
    def allowable(row):
        return reduce(lambda a, b: [x | y for x, y in izip(a, b)], row)

    def fits(a, b):
        return all(x & y for x, y in izip(a, b))

    def fix_col(n):
        """See if any value in a given column is fixed;
        if so, mark its corresponding row for future fixup."""
        c = [x[n] for x in can_do]
        cols[n] = [x for x in cols[n] if fits(x, c)]
        for i, x in enumerate(allowable(cols[n])):
            if x != can_do[i][n]:
                mod_rows.add(i)
                can_do[i][n] &= x

    def fix_row(n):
        """Ditto, for rows."""
        c = can_do[n]
        rows[n] = [x for x in rows[n] if fits(x, c)]
        for i, x in enumerate(allowable(rows[n])):
            if x != can_do[n][i]:
                mod_cols.add(i)
                can_do[n][i] &= x

    def show_gram(m):
        # If there's 'x', something is wrong.
        # If there's '?', needs more work.
        for x in m:
            print " ".join("x#.?"[i] for i in x)
        print

    w, h = len(vr), len(hr)
    rows = [gen_row(w, x) for x in hr]
    cols = [gen_row(h, x) for x in vr]
    can_do = map(allowable, rows)

    # Initially mark all columns for update.
    mod_rows, mod_cols = set(), set(xrange(w))

    while mod_cols:
        for i in mod_cols:
            fix_col(i)
        mod_cols = set()
        for i in mod_rows:
            fix_row(i)
        mod_rows = set()

    if all(can_do[i][j] in (1, 2) for j in xrange(w) for i in xrange(h)):
        print "Solution would be unique" # but could be incorrect!
    else:
        print "Solution may not be unique, doing exhaustive search:"

    # We actually do exhaustive search anyway. Unique solution takes
    # no time in this phase anyway, but just in case there's no
    # solution (could happen?).
    out = [0] * h

    def try_all(n = 0):
        if n >= h:
            for j in xrange(w):
                if [x[j] for x in out] not in cols[j]:
                    return 0
            show_gram(out)
            return 1
        sol = 0
        for x in rows[n]:
            out[n] = x
            sol += try_all(n + 1)
        return sol

    n = try_all()
    if not n:
        print "No solution."
    elif n == 1:
        print "Unique solution."
    else:
        print n, "solutions."
    print


def solve(p, show_runs=True):
    s = [[[ord(c) - ord('A') + 1 for c in w] for w in l.split()]
         for l in p.splitlines()]
    if show_runs:
        print "Horizontal runs:", s[0]
        print "Vertical runs:", s[1]
    deduce(s[0], s[1])


def main():
    # Read problems from file.
    fn = "nonogram_problems.txt"
    for p in (x for x in open(fn).read().split("\n\n") if x):
        solve(p)

    print "Extra example not solvable by deduction alone:"
    solve("B B A A\nB B A A")

    print "Extra example where there is no solution:"
    solve("B A A\nA A A")

main()
