import std.stdio, std.array, std.conv, std.algorithm;

int[][] board;
int[] given, start;

void setup(string s) {
    auto lines = s.split("\n");
    auto cols = lines[0].split().length;
    auto rows = lines.length;
    given.length = 0;

    board = new int[][](rows + 2, cols + 2);
    foreach (i; 0 .. rows + 2)
        board[i][] = -1;

    foreach (r, row; lines) {
        foreach (c, cell; row.split()) {
            switch (cell) {
                case "__" : board[r + 1][c + 1] = 0; break;
                case "."  : break;
                default :
                    int val = to!int(cell);
                    board[r + 1][c + 1] = val;
                    given ~= val;
                    if (val == 1) start = [r + 1, c + 1];
            }
        }
    }
    given.sort();
}

bool solve(int r, int c, int n, int next = 0) {
    if (n > given[$-1]) return true;

    if (board[r][c] && board[r][c] != n)
        return false;

    if (board[r][c] == 0 && given[next] == n)
        return false;

    int back = board[r][c];

    board[r][c] = n;
    foreach (i; -1 .. 2)
        foreach (j; -1 .. 2)
            if (solve(r + i, c + j, n + 1, next + (back == n)))
                return true;

    board[r][c] = back;
    return false;
}

void printBoard() {
    foreach (r; 0 .. board.length) {
        foreach (c; board[r])
            writef(c == -1 ? "   " : !c ? "__ " : "%2d ", c);
        write('\n');
    }
}

void main() {
    auto hi = "__ 33 35 __ __  .  .  .
                __ __ 24 22 __  .  .  .
                __ __ __ 21 __ __  .  .
                __ 26 __ 13 40 11  .  .
                27 __ __ __  9 __  1  .
                 .  . __ __ 18 __ __  .
                 .  .  .  . __  7 __ __
                 .  .  .  .  .  .  5 __";

    setup(hi);
    printBoard();
    solve(start[0], start[1], 1);
    printBoard();
}
