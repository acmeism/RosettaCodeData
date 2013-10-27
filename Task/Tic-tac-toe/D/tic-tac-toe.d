import std.stdio, std.string, std.algorithm, std.conv,
       std.random, std.ascii, std.array, std.range;

struct GameBoard {
    dchar[9] board = "123456789";
    enum : char { human = 'X', computer = 'O' }
    enum Game { going, humanWins, computerWins, draw }

    const pure nothrow invariant() {
        foreach (immutable i, immutable c; board)
            if (c.isDigit)
                assert(i == c - '1'); // in correct position?
            else
                assert(c == human || c == computer);
    }

    string toString() const pure {
        return format("%(%-(%s|%)\n-+-+-\n%)", board.dup.chunks(3));
    }

    bool isAvailable(in int i) const pure nothrow {
        if (i < 0 || i >= 9)
            return false;
        return board[i].isDigit;
    }

    int[] availablePositions() const pure nothrow {
        // not pure not nothrow:
        //return 9.iota.filter!(i => board[i].isDigit).array;
        int[] result;
        foreach (immutable i; 0 .. 9)
            if (isAvailable(i))
                result ~= i;
        return result;
    }

    Game winner() const pure nothrow {
        immutable wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                          [0, 3, 6], [1, 4, 7], [2, 5, 8],
                          [0, 4, 8], [2, 4, 6]];

        foreach (immutable win; wins) {
            immutable bw0 = board[win[0]];
            if (bw0.isDigit)
                continue; // nobody wins on this one

            if (bw0 == board[win[1]] && bw0 == board[win[2]])
                return bw0 == GameBoard.human ?
                              Game.humanWins :
                              Game.computerWins;
        }

        return availablePositions.empty ? Game.draw: Game.going;
    }

    bool finished() const pure nothrow {
        return winner != Game.going;
    }

    int computerMove() const // random move
    out(res) {
        assert(res >= 0 && res < 9 && isAvailable(res));
    } body {
        // return choice(availablePositions());
        return randomCover(availablePositions, rndGen).front;
    }
}


GameBoard playGame() {
    GameBoard board;
    bool playsHuman = true;

    while (!board.finished) {
        board.writeln;

        int move;
        if (playsHuman) {
            do {
                writef("Your move (available moves: %s)? ",
                       board.availablePositions.map!q{ a + 1 });
                readf("%d\n", &move);
                move--; // Zero based indexing.
                if (move < 0)
                    return board;
            } while (!board.isAvailable(move));
        } else
            move = board.computerMove();

        assert(board.isAvailable(move));
        writefln("\n%s chose %d", playsHuman ? "You" : "I", move + 1);
        board.board[move] = playsHuman ? GameBoard.human :
                                         GameBoard.computer;
        playsHuman = !playsHuman; // Switch player.
    }

    return board;
}


void main() {
    writeln("Tic-tac-toe game player.\n");
    immutable outcome = playGame.winner;

    final switch (outcome) {
        case GameBoard.Game.going:
            writeln("Game stopped.");
            break;
        case GameBoard.Game.humanWins:
            writeln("\nYou win!");
            break;
        case GameBoard.Game.computerWins:
            writeln("\nI win.");
            break;
        case GameBoard.Game.draw:
            writeln("\nDraw");
            break;
    }
}
