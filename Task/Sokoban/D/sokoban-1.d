import std.string, std.typecons, std.exception, std.algorithm;
import queue_usage2; // No queue in DMD 2.061 Phobos.

immutable struct Board {
    private enum El : char { floor=' ', wall='#', goal='.',
                             box='$', player='@', boxOnGoal='*' }
    private alias string CTable;
    private immutable size_t ncols;
    private immutable CTable sData, dData;
    private immutable int playerx, playery;

    this(in string[] board) pure nothrow
    in {
        foreach (row; board) {
            assert(row.length == board[0].length,
                   "Unequal board rows.");
            foreach (c; row)
                assert(c.inPattern(" #.$@*"), "Not valid input");
        }
    } body {
        immutable sMap=[' ':' ', '.':'.', '@':' ', '#':'#', '$':' '];
        immutable dMap=[' ':' ', '.':' ', '@':'@', '#':' ', '$':'*'];
        ncols = board[0].length;

        foreach (r, row; board)
            foreach (c, ch; row) {
                sData ~= sMap[ch];
                dData ~= dMap[ch];
                if (ch == El.player) {
                    playerx = c;
                    playery = r;
                }
            }
    }

    private bool move(in int x, in int y, in int dx,
                      in int dy, ref CTable data)
    const pure /*nothrow*/ {
        if (sData[(y+dy) * ncols + x+dx] == El.wall ||
            data[(y+dy) * ncols + x+dx] != El.floor)
            return false;

        auto data2 = data.dup; // not nothrow
        data2[y * ncols + x] = El.floor;
        data2[(y+dy) * ncols + x+dx] = El.player;
        data = assumeUnique(data2); // not enforced
        return true;
    }

    private bool push(in int x, in int y, in int dx,
                      in int dy, ref CTable data)
    const pure /*nothrow*/ {
        if (sData[(y+2*dy) * ncols + x+2*dx] == El.wall ||
            data[(y+2*dy) * ncols + x+2*dx] != El.floor)
            return false;

        auto data2 = data.dup; // not nothrow
        data2[y * ncols + x] = El.floor;
        data2[(y+dy) * ncols + x+dx] = El.player;
        data2[(y+2*dy) * ncols + x+2*dx] = El.boxOnGoal;
        data = assumeUnique(data2); // not enforced
        return true;
    }

    private bool isSolved(in CTable data) const pure nothrow {
        foreach (i, d; data)
            if ((sData[i] == El.goal) != (d == El.boxOnGoal))
                return false;
        return true;
    }

    string solve() pure {
        bool[immutable CTable] visitedSet = [dData: true];

        alias Tuple!(CTable, string, int, int) Four;
        GrowableCircularQueue!Four open;
        open.push(Four(dData, "", playerx, playery));

        immutable dirs = [tuple( 0, -1, 'u', 'U'),
                          tuple( 1,  0, 'r', 'R'),
                          tuple( 0,  1, 'd', 'D'),
                          tuple(-1,  0, 'l', 'L')];

        while (open.length) {
            //immutable (cur, cSol, x, y) = open.pop();
            immutable item = open.pop();
            immutable CTable cur = item[0];
            immutable string cSol = item[1];
            immutable int x = item[2];
            immutable int y = item[3];

            foreach (di; dirs) {
                CTable temp = cur;
                //immutable (dx, dy) = di[0 .. 2];
                immutable int dx = di[0];
                immutable int dy = di[1];

                if (temp[(y+dy) * ncols + x+dx] == El.boxOnGoal) {
                    if (push(x, y, dx, dy, temp) && temp !in visitedSet) {
                        if (isSolved(temp))
                            return cSol ~ di[3];
                        open.push(Four(temp, cSol ~ di[3], x+dx, y+dy));
                        visitedSet[temp] = true;
                    }
                } else if (move(x, y, dx, dy, temp) &&
                           temp !in visitedSet) {
                    if (isSolved(temp))
                        return cSol ~ di[2];
                    open.push(Four(temp, cSol ~ di[2], x+dx, y+dy));
                    visitedSet[temp] = true;
                }
            }
        }

        return "No solution";
    }
}

void main() {
    import std.stdio, core.memory;
    GC.disable(); // Uses about twice the memory
    immutable level =
"#######
#     #
#     #
#. #  #
#. $$ #
#.$$  #
#.#  @#
#######";

    immutable b = Board(level.splitLines());
    writeln(level, "\n\n", b.solve());
}
