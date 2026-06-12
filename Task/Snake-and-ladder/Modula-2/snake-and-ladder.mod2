MODULE SnakeAndLadder;
FROM FormatString IMPORT FormatString;
FROM RandomNumbers IMPORT Random;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

CONST SIXES_THROW_AGAIN = TRUE;

PROCEDURE NextSquare(sq : CARDINAL) : CARDINAL;
BEGIN
    (* Emulate a map for the ladders and snakes *)
    IF    sq =  4 THEN RETURN 14
    ELSIF sq =  9 THEN RETURN 31
    ELSIF sq = 17 THEN RETURN  7
    ELSIF sq = 20 THEN RETURN 38
    ELSIF sq = 28 THEN RETURN 84
    ELSIF sq = 40 THEN RETURN 59
    ELSIF sq = 51 THEN RETURN 67
    ELSIF sq = 54 THEN RETURN 34
    ELSIF sq = 62 THEN RETURN 19
    ELSIF sq = 63 THEN RETURN 81
    ELSIF sq = 64 THEN RETURN 60
    ELSIF sq = 71 THEN RETURN 91
    ELSIF sq = 87 THEN RETURN 24
    ELSIF sq = 93 THEN RETURN 73
    ELSIF sq = 95 THEN RETURN 75
    ELSIF sq = 99 THEN RETURN 78
    END;

    (* No snakes or ladders encountered *)
    RETURN sq
END NextSquare;

PROCEDURE Turn(player,square : CARDINAL) : CARDINAL;
VAR
    buf : ARRAY[0..63] OF CHAR;
    roll,next : CARDINAL;
BEGIN
    LOOP
        roll := Random(1,6);
        FormatString("Player %c, on square %c, rolls a %c", buf, player, square, roll);
        WriteString(buf);
        IF square + roll > 100 THEN
            WriteString(" but cannot move.");
            WriteLn
        ELSE
            square := square + roll;
            FormatString(" and moves to square %c\n", buf, square);
            WriteString(buf);
            IF square = 100 THEN RETURN 100 END;
            next := NextSquare(square);
            IF square < next THEN
                FormatString("Yay! Landed on a ladder. Climb up to %c.\n", buf, next);
                WriteString(buf);
                IF next = 100 THEN RETURN 100 END;
                square := next
            ELSIF square > next THEN
                FormatString("Oops! Landed on a snake. Slither down to %c.\n", buf, next);
                WriteString(buf);
                IF next = 100 THEN RETURN 100 END;
                square := next
            END
        END;
        IF (roll < 6) OR NOT SIXES_THROW_AGAIN THEN RETURN square END;
        WriteString("Rolled a 6 so roll again.");
        WriteLn
    END;

    RETURN square
END Turn;

(* Main *)
VAR
    buf : ARRAY[0..31] OF CHAR;
    players : ARRAY[0..2] OF CARDINAL;
    i,ns : CARDINAL;
BEGIN
    (* Initialize *)
    FOR i:=0 TO HIGH(players) DO
        players[i] := 1
    END;

    (* Game play *)
    LOOP
        FOR i:=0 TO HIGH(players) DO
            ns := Turn(i+1, players[i]);
            IF ns = 100 THEN
                FormatString("Player %c wins!\n", buf, i+1);
                WriteString(buf);
                EXIT
            END;
            players[i] := ns;
            WriteLn
        END
    END;

    ReadChar
END SnakeAndLadder.
