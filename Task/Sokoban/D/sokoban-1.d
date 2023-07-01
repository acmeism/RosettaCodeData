import std.string, std.typecons, std.exception, std.algorithm;
import queue_usage2; // No queue in Phobos 2.064.

const struct Board {
    private enum El { floor = ' ', wall = '#', goal = '.',
                      box = '$', player = '@', boxOnGoal='*' }
    private alias CTable = string;
    private immutable size_t ncols;
    private immutable CTable sData, dData;
    private immutable int playerx, playery;

    this(in string[] board) immutable pure nothrow @safe
    in {
        foreach (const row; board) {
            assert(row.length == board[0].length,
                   "Unequal board rows.");
            foreach (immutable c; row)
                assert(c.inPattern(" #.$@*"), "Not valid input");
        }
    } body {
        /*static*/ immutable sMap =
            [' ':' ', '.':'.', '@':' ', '#':'#', '$':' '];
        /*static*/ immutable dMap =
            [' ':' ', '.':' ', '@':'@', '#':' ', '$':'*'];
        ncols = board[0].length;

        int plx = 0, ply = 0;
        CTable sDataBuild, dDataBuild;

        foreach (immutable r, const row; board)
            foreach (immutable c, const ch; row) {
                sDataBuild ~= sMap[ch];
                dDataBuild ~= dMap[ch];
                if (ch == El.player) {
                    plx = c;
                    ply = r;
                }
            }

        this.sData = sDataBuild;
        this.dData = dDataBuild;
        this.playerx = plx;
        this.playery = ply;
    }

    private bool move(in int x, in int y, in int dx,
                      in int dy, ref CTable data)
    const pure nothrow /*@safe*/ {
        if (sData[(y + dy) * ncols + x + dx] == El.wall ||
            data[(y + dy) * ncols + x + dx] != El.floor)
            return false;

        auto data2 = data.dup;
        data2[y * ncols + x] = El.floor;
        data2[(y + dy) * ncols + x + dx] = El.player;
        data = data2.assumeUnique; // Not enforced.
        return true;
    }

    private bool push(in int x, in int y, in int dx,
                      in int dy, ref CTable data)
    const pure nothrow /*@safe*/ {
        if (sData[(y + 2 * dy) * ncols + x + 2 * dx] == El.wall ||
            data[(y + 2 * dy) * ncols + x + 2 * dx] != El.floor)
            return false;

        auto data2 = data.dup;
        data2[y * ncols + x] = El.floor;
        data2[(y + dy) * ncols + x + dx] = El.player;
        data2[(y + 2 * dy) * ncols + x + 2*dx] = El.boxOnGoal;
        data = data2.assumeUnique; // Not enforced.
        return true;
    }

    private bool isSolved(in CTable data)
    const pure nothrow @safe @nogc {
        foreach (immutable i, immutable d; data)
            if ((sData[i] == El.goal) != (d == El.boxOnGoal))
                return false;
        return true;
    }

    string solve() pure nothrow /*@safe*/ {
        bool[immutable CTable] visitedSet = [dData: true];

        alias Four = Tuple!(CTable, string, int, int);
        GrowableCircularQueue!Four open;
        open.push(Four(dData, "", playerx, playery));

        static immutable dirs = [tuple( 0, -1, 'u', 'U'),
                                 tuple( 1,  0, 'r', 'R'),
                                 tuple( 0,  1, 'd', 'D'),
                                 tuple(-1,  0, 'l', 'L')];

        while (!open.empty) {
            //immutable (cur, cSol, x, y) = open.pop;
            immutable item = open.pop;
            immutable cur = item[0];
            immutable cSol = item[1];
            immutable x = item[2];
            immutable y = item[3];

            foreach (immutable di; dirs) {
                CTable temp = cur;
                //immutable (dx, dy) = di[0 .. 2];
                immutable dx = di[0];
                immutable dy = di[1];

                if (temp[(y + dy) * ncols + x + dx] == El.boxOnGoal) {
                    if (push(x, y, dx, dy, temp) && temp !in visitedSet) {
                        if (isSolved(temp))
                            return cSol ~ di[3];
                        open.push(Four(temp, cSol ~ di[3], x + dx, y + dy));
                        visitedSet[temp] = true;
                    }
                } else if (move(x, y, dx, dy, temp) && temp !in visitedSet) {
                    if (isSolved(temp))
                        return cSol ~ di[2];
                    open.push(Four(temp, cSol ~ di[2], x + dx, y + dy));
                    visitedSet[temp] = true;
                }
            }
        }

        return "No solution";
    }
}

void main() {
    import std.stdio, core.memory;
    GC.disable; // Uses about twice the memory.

    immutable level =
"#######
#     #
#     #
#. #  #
#. $$ #
#.$$  #
#.#  @#
#######";

    immutable b = immutable(Board)(level.splitLines);
    writeln(level, "\n\n", b.solve);
}
