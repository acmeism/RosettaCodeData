import std.array;
import std.math;
import std.stdio;
import std.typecons;

enum Piece {
    empty,
    black,
    white,
}

alias position = Tuple!(int, "i", int, "j");

bool place(int m, int n, ref position[] pBlackQueens, ref position[] pWhiteQueens) {
    if (m == 0) {
        return true;
    }
    bool placingBlack = true;
    foreach (i; 0..n) {
        inner:
        foreach (j; 0..n) {
            auto pos = position(i, j);
            foreach (queen; pBlackQueens) {
                if (queen == pos || !placingBlack && isAttacking(queen, pos)) {
                    continue inner;
                }
            }
            foreach (queen; pWhiteQueens) {
                if (queen == pos || placingBlack && isAttacking(queen, pos)) {
                    continue inner;
                }
            }
            if (placingBlack) {
                pBlackQueens ~= pos;
                placingBlack = false;
            } else {
                pWhiteQueens ~= pos;
                if (place(m - 1, n, pBlackQueens, pWhiteQueens)) {
                    return true;
                }
                pBlackQueens.length--;
                pWhiteQueens.length--;
                placingBlack = true;
            }
        }
    }
    if (!placingBlack) {
        pBlackQueens.length--;
    }
    return false;
}

bool isAttacking(position queen, position pos) {
    return queen.i == pos.i
        || queen.j == pos.j
        || abs(queen.i - pos.i) == abs(queen.j - pos.j);
}

void printBoard(int n, position[] blackQueens, position[] whiteQueens) {
    auto board = uninitializedArray!(Piece[])(n * n);
    board[] = Piece.empty;

    foreach (queen; blackQueens) {
        board[queen.i * n + queen.j] = Piece.black;
    }
    foreach (queen; whiteQueens) {
        board[queen.i * n + queen.j] = Piece.white;
    }
    foreach (i,b; board) {
        if (i != 0 && i % n == 0) {
            writeln;
        }
        final switch (b) {
            case Piece.black:
                write("B ");
                break;
            case Piece.white:
                write("W ");
                break;
            case Piece.empty:
                int j = i / n;
                int k = i - j * n;

                if (j % 2 == k % 2) {
                    write("• "w);
                } else {
                    write("◦ "w);
                }
                break;
        }
    }
    writeln('\n');
}

void main() {
    auto nms = [
        [2, 1], [3, 1], [3, 2], [4, 1], [4, 2], [4, 3],
        [5, 1], [5, 2], [5, 3], [5, 4], [5, 5],
        [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6],
        [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7],
    ];
    foreach (nm; nms) {
        writefln("%d black and %d white queens on a %d x %d board:", nm[1], nm[1], nm[0], nm[0]);
        position[] blackQueens;
        position[] whiteQueens;
        if (place(nm[1], nm[0], blackQueens, whiteQueens)) {
            printBoard(nm[0], blackQueens, whiteQueens);
        } else {
            writeln("No solution exists.\n");
        }
    }
}
