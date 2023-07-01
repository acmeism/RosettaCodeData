import std.stdio, std.string;

struct Board {
    enum char spc = ' ';
    char[][] b = [[' ']]; // Set at least 1x1 board.
    int shiftx, shifty;

    void clear() pure nothrow {
        shiftx = shifty = 0;
        b = [['\0']];
    }

    void check(in int x, in int y) pure nothrow {
        while (y + shifty < 0) {
            auto newr = new char[b[0].length];
            newr[] = spc;
            b = newr ~ b;
            shifty++;
        }

        while (y + shifty >= b.length) {
            auto newr = new char[b[0].length];
            newr[] = spc;
            b ~= newr;
        }

        while (x + shiftx < 0) {
            foreach (ref c; b)
                c = [spc] ~ c;
            shiftx++;
        }

        while (x + shiftx >= b[0].length)
            foreach (ref c; b)
                c ~= [spc];
    }

    char opIndexAssign(in char value, in int x, in int y)
    pure nothrow {
        check(x, y);
        b[y + shifty][x + shiftx] = value;
        return value;
    }

    string toString() const pure {
        return format("%-(%s\n%)", b);
    }
}

struct Turtle {
    static struct TState {
        int[2] xy;
        int heading;
    }

    enum int[2][] dirs = [[1, 0],  [1,   1], [0,  1], [-1,  1],
                          [-1, 0], [-1, -1], [0, -1],  [1, -1]];
    enum string trace = r"-\|/-\|/";
    TState t;

    void reset() pure nothrow {
        t = typeof(t).init;
    }

    void turn(in int dir) pure nothrow {
        t.heading = (t.heading + 8 + dir) % 8;
    }

    void forward(ref Board b) pure nothrow {
        with (t) {
            xy[] += dirs[heading][];
            b[xy[0], xy[1]] = trace[heading];
            xy[] += dirs[heading][];
            b[xy[0], xy[1]] = b.spc;
        }
    }
}

void dragonX(in int n, ref Turtle t, ref Board b) pure nothrow {
    if (n >= 0) { // X -> X+YF+
        dragonX(n - 1, t, b);
        t.turn(2);
        dragonY(n - 1, t, b);
        t.forward(b);
        t.turn(2);
    }
}

void dragonY(in int n, ref Turtle t, ref Board b) pure nothrow {
    if (n >= 0) { // Y -> -FX-Y
        t.turn(-2);
        t.forward(b);
        dragonX(n - 1, t, b);
        t.turn(-2);
        dragonY(n - 1, t, b);
    }
}

void main() {
    Turtle t;
    Board b;
                      // Seed : FX
    t.forward(b);     // <- F
    dragonX(7, t, b); // <- X
    writeln(b);
}
