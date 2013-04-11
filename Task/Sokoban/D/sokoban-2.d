import core.stdc.stdio: printf, puts, fflush, stdout, putchar;
import core.stdc.stdlib: malloc, calloc, realloc, free, alloca, exit;
import core.stdc.string: memcpy, memset, memcmp;

alias ushort cidx_t;
alias uint hash_t;

// Board configuration is represented by an array of cell
// indices of player and boxes.
struct State {
    hash_t h;
    State* prev, next, qnext;
    cidx_t[0] c;
}

__gshared int w, h, n_boxes;
__gshared ubyte* board, goals, live;
__gshared size_t state_size, block_size = 32;
__gshared State* block_root, block_head;

State* newState(State* parent) nothrow {
    static State* next_of(State *s) nothrow {
        return cast(State*)(cast(ubyte*)s + state_size);
    }

    State *ptr;
    if (!block_head) {
        block_size *= 2;
        State* p = cast(State*)malloc(block_size * state_size);
        if (p == null) exit(1);
        State* q;
        p.next = block_root;
        block_root = p;
        ptr = cast(State*)(cast(ubyte*)p + state_size * block_size);
        p = block_head = next_of(p);
        for (q = next_of(p); q < ptr; p = q, q = next_of(q))
            p.next = q;
        p.next = null;
    }

    ptr = block_head;
    block_head = block_head.next;

    ptr.prev = parent;
    ptr.h = 0;
    return ptr;
}

void unNewState(State* p) nothrow {
    p.next = block_head;
    block_head = p;
}

enum Cell { space, wall, player, box }

// mark up positions where a box definitely should not be
void markLive(in int c) nothrow {
    immutable int y = c / w;
    immutable int x = c % w;
    if (live[c])
        return;

    live[c] = 1;
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

State* parseBoard(in int y, in int x, const char* s) nothrow {
    w = x, h = y;
    board = cast(ubyte*)calloc(w * h, ubyte.sizeof);
    if (board == null) exit(2);
    goals = cast(ubyte*)calloc(w * h, ubyte.sizeof);
    if (goals == null) exit(3);
    live = cast(ubyte*)calloc(w * h, ubyte.sizeof);
    if (live == null) exit(4);

    n_boxes = 0;
    for (int i = 0; s[i]; i++) {
        switch(s[i]) {
            case '#':
                board[i] = Cell.wall;
                continue;
            case '.', '+':
                goals[i] = 1;
                goto case;
            case '@':
                continue;
            case '*':
                goals[i] = 1;
                goto case;
            case '$':
                n_boxes++;
                continue;
            default:
                continue;
        }
    }

    enum int int_size = int.sizeof;
    state_size = (State.sizeof +
                  (1 + n_boxes) * cidx_t.sizeof +
                  int_size - 1)
                 / int_size * int_size;

    State* state = newState(null);

    for (cidx_t i = 0, j = 0; i < w * h; i++) {
        if (goals[i])
            markLive(i);
        if (s[i] == '$' || s[i] == '*')
            (cast(cidx_t*)&state.c)[++j] = i;
        else if (s[i] == '@' || s[i] == '+')
            (cast(cidx_t*)&state.c)[0] = i;
    }

    return state;
}

void showBoard(const State* s) nothrow {
    static immutable char*[] glyph1 = [" ", "#", "@", "$"];
    static immutable char*[] glyph2 = [".", "#", "@", "$"];

    auto ptr = cast(char*)alloca(w * h * char.sizeof);
    if (ptr == null) exit(5);
    auto b = ptr[0 .. w * h];

    memcpy(b.ptr, board, w * h);

    b[(cast(cidx_t*)&s.c)[0]] = Cell.player;
    for (int i = 1; i <= n_boxes; i++)
        b[(cast(cidx_t*)&s.c)[i]] = Cell.box;

    for (int i = 0; i < w * h; i++) {
        printf((goals[i] ? glyph2 : glyph1)[b[i]]);
        if (!((1 + i) % w))
            putchar('\n');
    }
}

// K&R hash function
void hash(State* s) nothrow {
    if (!s.h) {
        hash_t ha = 0;
        cidx_t* p = cast(cidx_t*)&s.c;
        for (int i = 0; i <= n_boxes; i++)
            ha = p[i] + 31 * ha;
        s.h = ha;
    }
}

__gshared State** buckets;
__gshared hash_t hash_size, fill_limit, filled;

void extendTable() nothrow {
    int old_size = hash_size;

    if (!old_size) {
        hash_size = 1024;
        filled = 0;
        fill_limit = hash_size * 3 / 4; // 0.75 load factor
    } else {
        hash_size *= 2;
        fill_limit *= 2;
    }

    buckets = cast(State**)realloc(buckets,
                                   (State*).sizeof * hash_size);
    if (buckets == null) exit(6);

    // rehash
    memset(buckets + old_size,
           0,
           (State*).sizeof * (hash_size - old_size));

    immutable hash_t bits = hash_size - 1;
    for (int i = 0; i < old_size; i++) {
        State *head = buckets[i];
        buckets[i] = null;
        while (head) {
            State* next = head.next;
            immutable int j = head.h & bits;
            head.next = buckets[j];
            buckets[j] = head;
            head = next;
        }
    }
}

State* lookup(State *s) nothrow {
    hash(s);
    State *f = buckets[s.h & (hash_size - 1)];
    for (; f; f = f.next) {
        if (!memcmp((cast(cidx_t*)&s.c), (cast(cidx_t*)&f.c),
                    cidx_t.sizeof * (1 + n_boxes)))
            break;
    }

    return f;
}

bool addToTable(State* s) nothrow {
    if (lookup(s)) {
        unNewState(s);
        return false;
    }

    if (filled++ >= fill_limit)
        extendTable();

    immutable hash_t i = s.h & (hash_size - 1);

    s.next = buckets[i];
    buckets[i] = s;
    return true;
}

bool success(const State* s) nothrow {
    for (int i = 1; i <= n_boxes; i++)
        if (!goals[(cast(cidx_t*)&s.c)[i]])
            return false;
    return true;
}

State* moveMe(State* s, int dy, int dx) nothrow {
    immutable int y = (cast(cidx_t*)&s.c)[0] / w;
    immutable int x = (cast(cidx_t*)&s.c)[0] % w;
    immutable int y1 = y + dy;
    immutable int x1 = x + dx;
    immutable int c1 = y1 * w + x1;

    if (y1 < 0 || y1 > h || x1 < 0 || x1 > w || board[c1] == Cell.wall)
        return null;

    int at_box = 0;
    for (int i = 1; i <= n_boxes; i++) {
        if ((cast(cidx_t*)&s.c)[i] == c1) {
            at_box = i;
            break;
        }
    }

    int c2;
    if (at_box) {
        c2 = c1 + dy * w + dx;
        if (board[c2] == Cell.wall || !live[c2])
            return null;
        for (int i = 1; i <= n_boxes; i++)
            if ((cast(cidx_t*)&s.c)[i] == c2)
                return null;
    }

    State* n = newState(s);
    memcpy((cast(cidx_t*)&n.c) + 1,
           (cast(cidx_t*)&s.c) + 1,
           cidx_t.sizeof * n_boxes);

    cidx_t* p = (cast(cidx_t*)&n.c);
    p[0] = cast(cidx_t)c1;

    if (at_box)
        p[at_box] = cast(cidx_t)c2;

    // Bubble sort
    for (int i = n_boxes; --i; ) {
        cidx_t t = 0;
        for (int j = 1; j < i; j++) {
            if (p[j] > p[j + 1])
                t = p[j], p[j] = p[j+1], p[j+1] = t;
        }
        if (!t)
            break;
    }

    return n;
}

__gshared State* next_level, done;

bool queueMove(State *s) nothrow {
    if (!s || !addToTable(s))
        return false;

    if (success(s)) {
        puts("\nSuccess!");
        done = s;
        return true;
    }

    s.qnext = next_level;
    next_level = s;
    return false;
}

bool do_move(State* s) nothrow {
    return queueMove(moveMe(s,  1,  0)) ||
           queueMove(moveMe(s, -1,  0)) ||
           queueMove(moveMe(s,  0,  1)) ||
           queueMove(moveMe(s,  0, -1));
}

void showMoves(in State* s) nothrow {
    if (s.prev)
        showMoves(s.prev);
    printf("\n");
    showBoard(s);
}

int main() nothrow {
    enum BIG = 0;

    static if (BIG == 0) {
        State* s = parseBoard(8, 7,
        "#######"~
        "#     #"~
        "#     #"~
        "#. #  #"~
        "#. $$ #"~
        "#.$$  #"~
        "#.#  @#"~
        "#######");

    } else static if (BIG == 1) {
        State* s = parseBoard(5, 13,
        "#############"~
        "#  #        #"~
        "# $$$$$$$  @#"~
        "#.......    #"
        "#############");

    } else {
        State* s = parseBoard(11, 19,
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
        "    #######        ");
    }

    showBoard(s);
    extendTable();
    queueMove(s);
    for (int i = 0; !done; i++) {
        printf("depth %d\r", i);
        fflush(stdout);

        State *head = next_level;
        for (next_level = null; head && !done; head = head.qnext)
            do_move(head);

        if (!next_level) {
            puts("No solution?");
            return 1;
        }
    }

    showMoves(done);

    version (none) {
        free(buckets);
        free(board);
        free(goals);
        free(live);

        while (block_root) {
            auto tmp = block_root.next;
            free(block_root);
            block_root = tmp;
        }
    }

    return 0;
}
