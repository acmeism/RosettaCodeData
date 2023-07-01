enum side = 8;
__gshared int[side] board;

bool isUnsafe(in int y) nothrow @nogc {
    immutable int x = board[y];
    foreach (immutable i; 1 .. y + 1) {
        immutable int t = board[y - i];
        if (t == x || t == x - i || t == x + i)
            return true;
    }

    return false;
}

void showBoard() nothrow @nogc {
    import core.stdc.stdio;

    static int s = 1;
    printf("\nSolution #%d:\n", s++);
    foreach (immutable y; 0 .. side) {
        foreach (immutable x; 0 .. side)
            putchar(board[y] == x ? 'Q' : '.');
        putchar('\n');
    }
}

void main() nothrow @nogc {
    int y = 0;
    board[0] = -1;

    while (y >= 0) {
        do {
            board[y]++;
        } while (board[y] < side && y.isUnsafe);

        if (board[y] < side) {
            if (y < (side - 1))
                board[++y] = -1;
            else
                showBoard;
        } else
            y--;
    }
}
