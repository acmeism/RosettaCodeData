#  Game 21 - an example in AWK language for Rosseta Code.

BEGIN {
    srand();
    GOAL = 21;
    best[0] = 1; best[1] = 1; best[2] = 3; best[3] = 2;

    print\
        "21 Game                                                          \n"\
        "                                                                 \n"\
        "21 is a two player game, the game is played by choosing a number \n"\
        "(1, 2, or 3) to be added to the running total. The game is won by\n"\
        "the player whose chosen number causes the running total to reach \n"\
        "exactly 21. The running total starts at zero.                    \n\n";

    newgame();
    prompt();

}

/[123]/ {
    move = strtonum($0);
    if (move + total <= GOAL) {
        update("human", strtonum($0));
        update("ai", best[total % 4]);
    }
    else
        invalid();
    prompt();
}
/[^123]/ {
    if ($0 == "quit") {
        print "goodbye";
        exit;
    }
    else {
        invalid();
        prompt();
    }
}

function prompt(){
    print "enter your choice (or type quit to exit): ";
}

function invalid(){
    print "invalid move";
}

function newgame() {
    print "\n---- NEW GAME ----\n";
    print "\nThe running total is currently zero.\n";
    total = 0;
    if (rand() < 0.5) {
        print "The first move is AI move.\n";
        update("ai", best[total % 4]);
    }
    else
        print "The first move is human move.\n";
}

function update(player, move) {
    printf "%8s:  %d = %d + %d\n\n", player, total + move, total, move;
    total += move;
    if (total == GOAL) {
        printf "The winner is %s.\n\n", player;
        newgame();
    }
}
