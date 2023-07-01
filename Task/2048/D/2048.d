import std.stdio, std.string, std.random;
import core.stdc.stdlib: exit;

struct G2048 {
    void gameLoop() {
        addTile;
        while (true) {
            if (moved)
                addTile;
            drawBoard;
            if (done)
                break;
            waitKey;
        }
        writeln(win ? "You win!" : "Game Over!");
    }

private:
    struct Tile {
        uint val = 0;
        bool blocked = false;
    }

    enum moveDir { up, down, left, right }
    enum uint side = 4;

    Tile[side][side] board;
    bool win = false, done = false, moved = true;
    uint score = 0;

    void drawBoard() const {
        writeln("SCORE: ", score, "\n");
        foreach (y; 0 .. side) {
            write("+------+------+------+------+\n| ");
            foreach (x; 0 .. side) {
                if (board[x][y].val)
                    writef("%4d", board[x][y].val);
                else
                    writef("%4s", " ");
                write(" | ");
            }
            writeln;
        }
        writeln("+------+------+------+------+\n");
    }

    void waitKey() /*@safe*/ {
        moved = false;
        write("(W)Up (S)Down (A)Left (D)Right (Q)Quit: ");
        auto c = readln.strip.toLower;

        switch (c) {
            case "w": move(moveDir.up);    break;
            case "a": move(moveDir.left);  break;
            case "s": move(moveDir.down);  break;
            case "d": move(moveDir.right); break;
            case "q": endGame;             break;
            default:                       break;
        }

        foreach (y; 0 .. side)
            foreach (x; 0 .. side)
                board[x][y].blocked = false;
    }

    void endGame() const {
        writeln("Game ended with score: ", score);
        exit(0);
    }

    void addTile() {
        foreach (y; 0 .. side) {
            foreach (x; 0 .. side) {
                if (!board[x][y].val) {
                    uint a, b;
                    do {
                        a = uniform(0, side);
                        b = uniform(0, side);
                    } while (board[a][b].val);

                    board[a][b].val = (uniform01 > 0.89) ? side : 2;
                    if (canMove)
                        return;
                }
            }
        }
        done = true;
    }

    bool canMove() const {
        foreach (y; 0 .. side)
            foreach (x; 0 .. side)
                if (!board[x][y].val)
                    return true;

        foreach (y; 0 .. side) {
            foreach (x; 0 .. side) {
                if (testAdd(x + 1, y, board[x][y].val) ||
                    testAdd(x - 1, y, board[x][y].val) ||
                    testAdd(x, y + 1, board[x][y].val) ||
                    testAdd(x, y - 1, board[x][y].val))
                return true;
            }
        }
        return false;
    }

    bool testAdd(uint x, uint y, uint v) const {
        if (x > 3 || y > 3)
            return false;
        return board[x][y].val == v;
    }

    void moveVertically(uint x, uint y, uint d) {
        if (board[x][y + d].val && board[x][y + d].val == board[x][y].val &&
            !board[x][y].blocked && !board[x][y + d].blocked) {
            board[x][y].val = 0;
            board[x][y + d].val *= 2;
            score += board[x][y + d].val;
            board[x][y + d].blocked = true;
            moved = true;
        } else if (!board[x][y + d].val && board[x][y].val) {
            board[x][y + d].val = board[x][y].val;
            board[x][y].val = 0;
            moved = true;
        }

        if (d > 0) {
            if (y + d < 3)
                moveVertically(x, y + d,  1);
        } else {
            if (y + d > 0)
                moveVertically(x, y + d, -1);
        }
    }

    void moveHorizontally(uint x, uint y, uint d) {
        if (board[x + d][y].val && board[x + d][y].val == board[x][y].val &&
            !board[x][y].blocked && !board[x + d][y].blocked) {
            board[x][y].val = 0;
            board[x + d][y].val *= 2;
            score += board[x + d][y].val;
            board[x + d][y].blocked = true;
            moved = true;
        } else if (!board[x + d][y].val && board[x][y].val) {
            board[x + d][y].val = board[x][y].val;
            board[x][y].val = 0;
            moved = true;
        }

        if (d > 0) {
            if (x + d < 3)
                moveHorizontally(x + d, y,  1);
        } else {
            if (x + d > 0)
                moveHorizontally(x + d, y, -1);
        }
    }

    void move(moveDir d) {
        final switch (d) with(moveDir) {
            case up:
                foreach (x; 0 .. side)
                    foreach (y; 1 .. side)
                        if (board[x][y].val)
                            moveVertically(x, y, -1);
                break;
            case down:
                foreach (x; 0 .. side)
                    foreach_reverse (y; 0 .. 3)
                        if (board[x][y].val)
                            moveVertically(x, y, 1);
                break;
            case left:
                foreach (y; 0 .. side)
                    foreach (x; 1 .. side)
                        if (board[x][y].val)
                            moveHorizontally(x, y, -1);
                break;
            case right:
                foreach (y; 0 .. side)
                    foreach_reverse (x; 0 .. 3)
                        if (board[x][y].val)
                            moveHorizontally(x, y, 1);
        }
    }
}

void main() /*safe*/ {
    G2048 g;
    g.gameLoop;
}
