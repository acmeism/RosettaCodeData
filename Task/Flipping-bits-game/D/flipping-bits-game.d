import std.stdio, std.random, std.ascii, std.string, std.range,
       std.algorithm, std.conv;

enum N = 3; // Board side.
static assert(N <= lowercase.length);
enum columnIDs = lowercase[0 .. N];
alias Board = ubyte[N][N];

void flipBits(ref Board board, in size_t count=1) {
    foreach (immutable _; 0 .. count)
        board[uniform(0, $)][uniform(0, $)] ^= 1;
}

void notRow(ref Board board, in size_t i) pure nothrow {
    board[i][] ^= 1;
}

void notColumn(ref Board board, in size_t i) pure nothrow {
    foreach (ref row; board)
        row[i] ^= 1;
}

Board generateGameBoard(in ref Board target) {
    // board is generated with many flips, to keep parity unchanged.
    Board board = target;
    while (board == target)
        foreach (immutable _; 0 .. 2 * N)
            [&notRow, &notColumn][uniform(0, 2)](board, uniform(0, N));
    return board;
}

void show(in ref Board board, in string comment) {
    comment.writeln;
    writefln("     %-(%c %)", columnIDs);
    foreach (immutable j, const row; board)
        writefln("  %2d %-(%d %)", j + 1, row);
}

void main() {
    "T prints the target, and Q exits.\n".writeln;
    // Create target and flip some of its bits randomly.
    Board target;
    flipBits(target, uniform(0, N) + 1);
    show(target, "Target configuration is:");

    auto board = generateGameBoard(target);
    immutable prompt = format("  1-%d / %s-%s to flip, or T, Q: ",
                              N, columnIDs[0], columnIDs.back);
    uint move = 1;
    while (board != target) {
        show(board, format("\nMove %d:", move));
        prompt.write;
        immutable ans = readln.strip;

        if (ans.length == 1 && columnIDs.canFind(ans)) {
            board.notColumn(columnIDs.countUntil(ans));
            move++;
        } else if (iota(1, N + 1).map!text.canFind(ans)) {
            board.notRow(ans.to!uint - 1);
            move++;
        } else if (ans == "T") {
            show(target, "Target configuration is:");
        } else if (ans == "Q") {
            return "Game stopped.".writeln;
        } else
            writefln("  Wrong input '%s'. Try again.\n", ans.take(9));
    }

    "\nWell done!".writeln;
}
