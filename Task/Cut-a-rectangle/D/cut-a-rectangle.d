import core.stdc.stdio, core.stdc.stdlib,
       core.stdc.string, std.typetuple;

template Range(int stop) { // for manual loop unroll
    static if (stop <= 0)
        alias TypeTuple!() Range;
    else
        alias TypeTuple!(Range!(stop-1), stop-1) Range;
}

enum int[2][4] dir = [[0, -1], [-1, 0], [0, 1], [1, 0]];

__gshared ubyte[] grid;
__gshared int w, h, len;
__gshared ulong cnt;
__gshared int[4] next;

void walk(in int y, in int x) nothrow {
    if (!y || y == h || !x || x == w) {
        cnt += 2;
        return;
    }

    immutable int t = y * (w + 1) + x;
    grid[t]++;
    grid[len - t]++;

    foreach (i; Range!4) // manual loop unroll
        if (!grid[t + next[i]])
            walk(y + dir[i][0], x + dir[i][1]);

    grid[t]--;
    grid[len - t]--;
}

ulong solve(in int hh, in int ww, in bool recur) nothrow {
    h = (hh & 1) ? ww : hh;
    w = (hh & 1) ? hh : ww;

    if (h & 1) return 0;
    if (w == 1) return 1;
    if (w == 2) return h;
    if (h == 2) return w;

    immutable int cy = h / 2;
    immutable int cx = w / 2;

    len = (h + 1) * (w + 1);
    {
        // grid = new ubyte[len]; // slower
        ubyte* ptr = cast(ubyte*)alloca(len);
        if (ptr == null)
            exit(1);
        grid = ptr[0 .. len];
    }
    grid[] = 0;
    len--;

    //next = [-1, -w - 1, 1, w + 1]; // slow
    next[0] = -1;
    next[1] = -w - 1;
    next[2] = 1;
    next[3] = w + 1;

    if (recur)
        cnt = 0;
    foreach (x; cx + 1 .. w) {
        immutable int t = cy * (w + 1) + x;
        grid[t] = 1;
        grid[len - t] = 1;
        walk(cy - 1, x);
    }
    cnt++;

    if (h == w)
        cnt *= 2;
    else if (!(w & 1) && recur)
        solve(w, h, 0);

    return cnt;
}

void main() {
    foreach (y; 1 .. 11)
        foreach (x; 1 .. y + 1)
            if (!(x & 1) || !(y & 1))
                printf("%d x %d: %llu\n", y, x, solve(y, x, true));
}
