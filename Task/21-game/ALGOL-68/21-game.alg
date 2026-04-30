IF  print( ( "Player who reaches 21, wins", newline ) );    # 21 game - based on the EasyLang sample #
    INT      human   = 1, computer = 2;
    []STRING name    = ( "Human   ", "Computer" );
    INT      player := human, sum := 0;
    STRING   a      := "?";
    WHILE a /= "y" AND a /= "n" AND a /= "q" DO
        print( ( "Do you want to go first (y/n/q) " ) );
        read( ( a, newline ) );
        IF a = "n" THEN player := computer FI
    OD;
    a /= "q"
THEN
    WHILE
        INT add := IF player = human THEN
                       a := "?";
                       WHILE a /= "q" AND a /= "1" AND a /= "2" AND a /= "3" DO
                           print( ( newline, "Add 1, 2 or 3 (q to quit) " ) );
                           read( ( a, newline ) )
                       OD;
                       IF a = "1" THEN 1 ELIF a = "2" THEN 2 ELSE 3 FI
                   ELIF sum MOD 4 = 1 THEN
                       # player = computer, optimal move not possible #
                       ENTIER ( random * 3 ) + 1
                   ELSE
                       # player = computer, can make the optimal move #
                       4 - ( sum + 3 ) MOD 4
                   FI;
        sum +:= add;
        IF a /= "q" THEN
            print( ( name[ player ], ": ", whole( add, 0 ), " --> ", whole( sum, 0 ), newline ) )
        FI;
        a /= "q" AND sum < 21
    DO
        player := IF player = human THEN computer ELSE human FI
    OD;
    IF a /= "q" THEN
        print( ( newline ) );
        print( ( IF player = human THEN "Congratulations, you won" ELSE "Sorry, you lost" FI ) );
        print( ( newline ) )
    FI
FI
