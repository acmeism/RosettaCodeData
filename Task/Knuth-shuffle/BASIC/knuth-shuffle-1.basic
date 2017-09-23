RANDOMIZE TIMER

DIM cards(51) AS INTEGER
DIM L0 AS LONG, card AS LONG

PRINT "before:"
FOR L0 = 0 TO 51
    cards(L0) = L0
    PRINT LTRIM$(STR$(cards(L0))); " ";
NEXT

FOR L0 = 51 TO 0 STEP -1
    card = INT(RND * (L0 + 1))
    IF card <> L0 THEN SWAP cards(card), cards(L0)
NEXT

PRINT : PRINT "after:"
FOR L0 = 0 TO 51
    PRINT LTRIM$(STR$(cards(L0))); " ";
NEXT
PRINT
