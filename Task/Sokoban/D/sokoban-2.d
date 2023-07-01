import core.stdc.stdio: printf, puts, fflush, stdout, putchar;
import core.stdc.stdlib: malloc, calloc, realloc, free, alloca, exit;

enum Cell : ubyte { space, wall, player, box }
alias CellIndex = ushort;
alias Thash = uint;


/// Board configuration is represented by an array of cell
/// indices of player and boxes.
struct State { // Variable length struct.
    Thash h;
    State* prev, next, qNext;
    CellIndex[0] c_;

    CellIndex get(in size_t i) inout pure nothrow @nogc {
        return c_.ptr[i];
    }

    void set(in size_t i, in CellIndex v) pure nothrow @nogc {
        c_.ptr[i] = v;
    }

    CellIndex[] slice(in size_t i, in size_t j) pure nothrow @nogc return {
        return c_.ptr[i .. j];
    }
}


__gshared Cell[] board;
__gshared bool[] goals, live;
__gshared size_t w, h, nBoxes, stateSize, blockSize = 32;
__gshared State* blockRoot, blockHead, nextLevel, done;
__gshared State*[] buckets;
__gshared Thash hashSize, fillLimit, filled;


State* newState(State* parent) nothrow @nogc {
    static State* nextOf(State *s) nothrow @nogc {
        return cast(State*)(cast(ubyte*)s + stateSize);
    }

    State* ptr;
    if (!blockHead) {
        blockSize *= 2;
        auto p = cast(State*)malloc(blockSize * stateSize);
        if (p == null)
            exit(1);

        p.next = blockRoot;
        blockRoot = p;
        ptr = cast(State*)(cast(ubyte*)p + stateSize * blockSize);
        p = blockHead = nextOf(p);
        for (auto q = nextOf(p); q < ptr; p = q, q = nextOf(q))
            p.next = q;
        p.next = null;
    }

    ptr = blockHead;
    blockHead = blockHead.next;
    ptr.prev = parent;
    ptr.h = 0;
    return ptr;
}


void unNewState(State* p) nothrow @nogc {
    p.next = blockHead;
    blockHead = p;
}


/// Mark up positions where a box definitely should not be.
void markLive(in size_t c) nothrow @nogc {
    immutable y = c / w;
    immutable x = c % w;
    if (live[c])
        return;

    live[c] = true;
    if (y > 1 && board[c - w] != Cell.wall &&
        board[c - w * 2] != Cell.wall)
        markLive(c - w);
    if (y < h - 2 && board[c + w] != Cell.wall &&
        board[c + w * 2] != Cell.wall)
        markLive(c + w);
    if (x > 1 && board[c - 1] != Cell.wall &&
        board[c - 2] != Cell.wall)
        markLive(c - 1);
    if (x < w - 2 && board[c + 1] != Cell.wall &&
        board[c + 2] != Cell.wall)
        markLive(c + 1);
}


State* parseBoard(in size_t y, in size_t x, in char* s) nothrow @nogc {
    static T[] myCalloc(T)(in size_t n) nothrow @nogc {
        auto ptr = cast(T*)calloc(n, T.sizeof);
        if (ptr == null)
            exit(1);
        return ptr[0 .. n];
    }

    w = x, h = y;
    board = myCalloc!Cell(w * h);
    goals = myCalloc!bool(w * h);
    live = myCalloc!bool(w * h);

    nBoxes = 0;
    for (int i = 0; s[i]; i++) {
        switch(s[i]) {
            case '#':
                board[i] = Cell.wall;
                continue;
            case '.', '+':
                goals[i] = true;
                goto case;
            case '@':
                continue;
            case '*':
                goals[i] = true;
                goto case;
            case '$':
                nBoxes++;
                continue;
            default:
                continue;
        }
    }

    enum int intSize = int.sizeof;
    stateSize = (State.sizeof +
                  (1 + nBoxes) * CellIndex.sizeof +
                  intSize - 1)
                 / intSize * intSize;

    auto state = null.newState;

    for (CellIndex i = 0, j = 0; i < w * h; i++) {
        if (goals[i])
            i.markLive;
        if (s[i] == '$' || s[i] == '*')
            state.set(++j, i);
        else if (s[i] == '@' || s[i] == '+')
            state.set(0, i);
    }

    return state;
}


/// K&R hash function.
void hash(State* s, in size_t nBoxes) pure nothrow @nogc {
    if (!s.h) {
        Thash ha = 0;
        foreach (immutable i; 0 .. nBoxes + 1)
            ha = s.get(i) + 31 * ha;
        s.h = ha;
    }
}


void extendTable() nothrow @nogc {
    int oldSize = hashSize;

    if (!oldSize) {
        hashSize = 1024;
        filled = 0;
        fillLimit = hashSize * 3 / 4; // 0.75 load factor.
    } else {
        hashSize *= 2;
        fillLimit *= 2;
    }

    auto ptr = cast(State**)realloc(buckets.ptr,
                                    (State*).sizeof * hashSize);
    if (ptr == null)
        exit(6);
    buckets = ptr[0 .. hashSize];
    buckets[oldSize .. hashSize] = null;

    immutable Thash bits = hashSize - 1;
    foreach (immutable i; 0 .. oldSize) {
        auto head = buckets[i];
        buckets[i] = null;
        while (head) {
            auto next = head.next;
            immutable j = head.h & bits;
            head.next = buckets[j];
            buckets[j] = head;
            head = next;
        }
    }
}


State* lookup(State *s) nothrow @nogc {
    s.hash(nBoxes);
    auto f = buckets[s.h & (hashSize - 1)];
    for (; f; f = f.next) {
        if (s.slice(0, nBoxes + 1) == f.slice(0, nBoxes + 1))
            break;
    }

    return f;
}


bool addToTable(State* s) nothrow @nogc {
    if (s.lookup) {
        s.unNewState;
        return false;
    }

    if (filled++ >= fillLimit)
        extendTable;

    immutable Thash i = s.h & (hashSize - 1);

    s.next = buckets[i];
    buckets[i] = s;
    return true;
}


bool success(in State* s) nothrow @nogc {
    foreach (immutable i; 1 .. nBoxes + 1)
        if (!goals[s.get(i)])
            return false;
    return true;
}


State* moveMe(State* s, in int dy, in int dx) nothrow @nogc {
    immutable int y = s.get(0) / w;
    immutable int x = s.get(0) % w;
    immutable int y1 = y + dy;
    immutable int x1 = x + dx;
    immutable int c1 = y1 * w + x1;

    if (y1 < 0 || y1 > h || x1 < 0 || x1 > w || board[c1] == Cell.wall)
        return null;

    int atBox = 0;
    foreach (immutable i; 1 .. nBoxes + 1)
        if (s.get(i) == c1) {
            atBox = i;
            break;
        }

    int c2;
    if (atBox) {
        c2 = c1 + dy * w + dx;
        if (board[c2] == Cell.wall || !live[c2])
            return null;
        foreach (immutable i; 1 .. nBoxes + 1)
            if (s.get(i) == c2)
                return null;
    }

    auto n = s.newState;
    n.slice(1, nBoxes + 1)[] = s.slice(1, nBoxes + 1);

    n.set(0, cast(CellIndex)c1);

    if (atBox)
        n.set(atBox, cast(CellIndex)c2);

    // Bubble sort.
    for (size_t i = nBoxes; --i; ) {
        CellIndex t = 0;
        foreach (immutable j; 1 .. i) {
            if (n.get(j) > n.get(j + 1)) {
                t = n.get(j);
                n.set(j, n.get(j + 1));
                n.set(j + 1, t);
            }
        }
        if (!t)
            break;
    }

    return n;
}


bool queueMove(State *s) nothrow @nogc {
    if (!s || !s.addToTable)
        return false;

    if (s.success) {
        "\nSuccess!".puts;
        done = s;
        return true;
    }

    s.qNext = nextLevel;
    nextLevel = s;
    return false;
}


bool doMove(State* s) nothrow @nogc {
    return s.moveMe( 1,  0).queueMove ||
           s.moveMe(-1,  0).queueMove ||
           s.moveMe( 0,  1).queueMove ||
           s.moveMe( 0, -1).queueMove;
}


void showBoard(in State* s) nothrow @nogc {
    static immutable glyphs1 = " #@$", glyphs2 = ".#@$";

    auto ptr = cast(ubyte*)alloca(w * h * ubyte.sizeof);
    if (ptr == null)
        exit(5);
    auto b = ptr[0 .. w * h];
    b[] = cast(typeof(b))board[];

    b[s.get(0)] = Cell.player;
    foreach (immutable i; 1 .. nBoxes + 1)
        b[s.get(i)] = Cell.box;

    foreach (immutable i, immutable bi; b) {
        putchar((goals[i] ? glyphs2 : glyphs1)[bi]);
        if (!((1 + i) % w))
            '\n'.putchar;
    }
}


void showMoves(in State* s) nothrow @nogc {
    if (s.prev)
        s.prev.showMoves;
    "\n".printf;
    s.showBoard;
}

int main() nothrow @nogc {
    // Workaround for @nogc.
    alias ctEval(alias expr) = expr;

    enum uint problem = 0;

    static if (problem == 0) {
        auto s = parseBoard(8, 7, ctEval!(
        "#######"~
        "#     #"~
        "#     #"~
        "#. #  #"~
        "#. $$ #"~
        "#.$$  #"~
        "#.#  @#"~
        "#######"));

    } else static if (problem == 1) {
        auto s = parseBoard(5, 13, ctEval!(
        "#############"~
        "#  #        #"~
        "# $$$$$$$  @#"~
        "#.......    #"
        "#############"));

    } else static if (problem == 2) {
        auto s = parseBoard(11, 19, ctEval!(
        "    #####          "~
        "    #   #          "~
        "    #   #          "~
        "  ### #$##         "~
        "  #      #         "~
        "### #$## #   ######"~
        "#   # ## #####   .#"~
        "# $   $         ..#"~
        "##### ### #@##   .#"~
        "    #     #########"~
        "    #######        "));
    } else {
        asset(0, "Not present problem.");
    }

    s.showBoard;
    extendTable;
    s.queueMove;
    for (int i = 0; !done; i++) {
        printf("depth %d\r", i);
        stdout.fflush;

        auto head = nextLevel;
        for (nextLevel = null; head && !done; head = head.qNext)
            head.doMove;

        if (!nextLevel) {
            "No solution?".puts;
            return 1;
        }
    }

    done.showMoves;

    version (none) { // Free all allocated memory.
        buckets.ptr.free;
        board.ptr.free;
        goals.ptr.free;
        live.ptr.free;

        while (blockRoot) {
            auto tmp = blockRoot.next;
            blockRoot.free;
            blockRoot = tmp;
        }
    }

    return 0;
}
