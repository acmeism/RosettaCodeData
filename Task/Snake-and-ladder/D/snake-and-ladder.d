import std.stdio;

//Board layout, start square to end square
auto snl() {
    // Workaround for not being able to static initialize an AA
    int[int] temp;
    temp[4] = 14;
    temp[9] = 31;
    temp[17] = 7;
    temp[20] = 38;
    temp[28] = 84;
    temp[40] = 59;
    temp[51] = 67;
    temp[54] = 34;
    temp[62] = 19;
    temp[63] = 81;
    temp[64] = 60;
    temp[71] = 91;
    temp[87] = 24;
    temp[93] = 73;
    temp[95] = 75;
    temp[99] = 78;
    return temp;
}

int turn(int player, int square) {
    import std.random;

    auto roll = uniform!"[]"(1, 6);
    write("Player ", player, " on square ", square, " rolls a ", roll);
    if (square + roll > 100) {
        writeln(" but cannot move. Next players turn.");
        return square;
    } else {
        square += roll;
        writeln(" and moves to square ", square);
    }

    auto next = snl().get(square, square);
    if (square < next) {
        writeln("Yay! Landed on a ladder. Climb up to ", next);
    } else if (square > next) {
        writeln("Oops! Landed on a snake. Slither down to ", next);
    }
    return next;
}

void main() {
    // three players starting on square one
    auto players = [1, 1, 1];

    while(true) {
        foreach(i,s; players) {
            auto ns = turn(cast(int)i+1, s);
            if (ns == 100) {
                writeln("Player ", i+1, " wins!");
                return;
            }
            players[i] = ns;
            writeln;
        }
    }
}
