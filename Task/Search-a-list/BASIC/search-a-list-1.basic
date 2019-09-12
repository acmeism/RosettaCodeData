DATA foo, bar, baz, quux, quuux, quuuux, bazola, ztesch, foo, bar, thud, grunt
DATA foo, bar, bletch, foo, bar, fum, fred, jim, sheila, barney, flarp, zxc
DATA spqr, wombat, shme, foo, bar, baz, bongo, spam, eggs, snork, foo, bar
DATA zot, blarg, wibble, toto, titi, tata, tutu, pippo, pluto, paperino, aap
DATA noot, mies, oogle, foogle, boogle, zork, gork, bork

DIM haystack(54) AS STRING
DIM needle AS STRING, found AS INTEGER, L0 AS INTEGER

FOR L0 = 0 TO 54
    READ haystack(L0)
NEXT

DO
    INPUT "Word to search for? (Leave blank to exit) ", needle
    IF needle <> "" THEN
        FOR L0 = 0 TO UBOUND(haystack)
            IF UCASE$(haystack(L0)) = UCASE$(needle) THEN
                found = 1
                PRINT "Found "; CHR$(34); needle; CHR$(34); " at index "; LTRIM$(STR$(L0))
            END IF
        NEXT
        IF found < 1 THEN
            PRINT CHR$(34); needle; CHR$(34); " not found"
        END IF
    ELSE
        EXIT DO
    END IF
LOOP
