MODULE CardShuffles;
FROM FormatString IMPORT FormatString;
FROM RandomNumbers IMPORT Random;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteCard(c : CARDINAL);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%c", buf, c);
    WriteString(buf)
END WriteCard;

PROCEDURE WriteInteger(i : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%02i", buf, i);
    WriteString(buf)
END WriteInteger;

PROCEDURE WriteIntArray(array : ARRAY OF INTEGER);
VAR i : CARDINAL;
BEGIN
    WriteString("[");
    FOR i:=0 TO HIGH(array) DO
        IF i>0 THEN
            WriteString(", ");
        END;
        WriteInteger(array[i]);
    END;
    WriteString("]")
END WriteIntArray;

(*---------------------------------------*)

TYPE Deck_t = ARRAY[0..20] OF INTEGER;

PROCEDURE InitDeck(VAR deck : ARRAY OF INTEGER);
VAR i : CARDINAL;
BEGIN
    FOR i:=0 TO HIGH(deck) DO
        deck[i] := i + 1
    END
END InitDeck;

PROCEDURE RiffleShuffle(VAR deck : Deck_t; flips : CARDINAL);
VAR
    n,cutPoint,nlp,lp,rp,bound : CARDINAL;
    nl : Deck_t;
BEGIN
    FOR n:=1 TO flips DO
        cutPoint := HIGH(deck) / 2;
        IF Random(0, 2) > 0 THEN
            cutPoint := cutPoint + Random(0, HIGH(deck) / 10);
        ELSE
            cutPoint := cutPoint - Random(0, HIGH(deck) / 10);
        END;

        nlp := 0;
        lp := 0;
        rp := cutPoint;

        WHILE (lp <= cutPoint) AND (rp < HIGH(deck)) DO
            (* Allow for an imperfect riffling so that more than one card can come from the same side in a row
               biased towards the side with more cards. Remove the IF statement for perfect riffling. *)
            bound := (cutPoint - lp) * 50 / (HIGH(deck) - rp);
            IF Random(0, 50)>= bound THEN
                nl[nlp] := deck[rp];
                INC(nlp);
                INC(rp);
            ELSE
                nl[nlp] := deck[lp];
                INC(nlp);
                INC(lp);
            END
        END;
        WHILE lp <= cutPoint DO
            nl[nlp] := deck[lp];
            INC(nlp);
            INC(lp);
        END;
        WHILE rp < HIGH(deck) DO
            nl[nlp] := deck[rp];
            INC(nlp);
            INC(rp);
        END;

        deck := nl
    END
END RiffleShuffle;

PROCEDURE OverhandShuffle(VAR mainHand : Deck_t; passes : CARDINAL);
VAR
    n,cutSize,mp,op,tp,i : CARDINAL;
    otherHand,temp : Deck_t;
BEGIN
    FOR n:=1 TO passes DO
        mp := 0;
        op := 0;
        FOR i:=0 TO HIGH(otherHand) DO
            otherHand[i] := 9999
        END;

        WHILE mp < HIGH(mainHand) DO
            (* Cut at up to 20% of the way through the deck *)
            cutSize := Random(0, HIGH(mainHand) / 5) + 1;
            tp := 0;

            (* Grab the next cut up to the end of the cards left in the main hand *)
            i:=0;
            WHILE (i < cutSize) AND (mp < HIGH(mainHand)) DO
                temp[tp] := mainHand[mp];
                INC(tp);
                INC(mp);
                INC(i);

                IF mp = HIGH(mainHand) THEN
                    temp[tp] := mainHand[mp];
                    INC(tp);
                    INC(mp);
                END
            END;

            (* Add them to the cards in the other hand, sometimes to the front and sometimes to the back *)
            IF Random(0, 10) >= 1 THEN
                (* otherHand = temp + otherHand *)

                (* copy other hand elements up by temp spaces *)
                i := op;
                WHILE (i > 0) AND (op > 0) DO
                    otherHand[tp + i] := otherHand[i];
                    DEC(i)
                END;
                IF op > 0 THEN
                    otherHand[tp] := otherHand[0]
                END;

                (* copy the elements of temp into the front of other hand *)
                FOR i:=0 TO tp-1 DO
                    otherHand[i] := temp[i]
                END
           ELSE
                (* otherHand = otherHand + temp *)
                FOR i:=0 TO tp DO
                    otherHand[op+i] := temp[i]
                END
            END;
            op := op + tp
        END;

        (* Move the cards back to the main hand *)
        mainHand := otherHand
    END
END OverhandShuffle;

(* Main *)
VAR deck : Deck_t;
BEGIN
    WriteString("Riffle shuffle");
    WriteLn;
    InitDeck(deck);
    WriteIntArray(deck);
    WriteLn;
    RiffleShuffle(deck, 10);
    WriteIntArray(deck);
    WriteLn;
    WriteLn;

    WriteString("Riffle shuffle");
    WriteLn;
    InitDeck(deck);
    WriteIntArray(deck);
    WriteLn;
    RiffleShuffle(deck, 1);
    WriteIntArray(deck);
    WriteLn;
    WriteLn;

    WriteString("Overhand shuffle");
    WriteLn;
    InitDeck(deck);
    WriteIntArray(deck);
    WriteLn;
    OverhandShuffle(deck, 10);
    WriteIntArray(deck);
    WriteLn;
    WriteLn;

    WriteString("Overhand shuffle");
    WriteLn;
    InitDeck(deck);
    WriteIntArray(deck);
    WriteLn;
    OverhandShuffle(deck, 1);
    WriteIntArray(deck);
    WriteLn;

    ReadChar;
END CardShuffles.
