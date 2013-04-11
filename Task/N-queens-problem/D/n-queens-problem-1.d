import std.stdio;

enum int SIDE = 8;
int[SIDE] board;

bool unsafe(in int y) nothrow {
    immutable int x = board[y];
    foreach (i; 1 .. y + 1) {
        int t = board[y - i];
        if ((t == x) || (t == x - i) || (t == x + i))
            return true;
    }

    return false;
}

void showBoard() {
    static int s = 1;
    writeln("\nSolution #", s++);
    foreach (y; 0 .. SIDE) {
        foreach (x; 0 .. SIDE)
            write(board[y] == x ? '*' : '.');
        writeln();
    }
}

void main() {
    int y = 0;
    board[0] = -1;

    while (y >= 0) {
        do {
            board[y]++;
        } while (board[y] < SIDE && unsafe(y));

        if (board[y] < SIDE) {
            if (y < (SIDE - 1))
                board[++y] = -1;
            else
                showBoard();
        } else
            y--;
    }
}
