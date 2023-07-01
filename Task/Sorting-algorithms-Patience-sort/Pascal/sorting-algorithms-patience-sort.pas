PatienceSortTask (Output);

CONST MaxSortSize = 1024;       { A power of two. }
      MaxWinnersSize = (2 * MaxSortSize) - 1;

TYPE PilesArrayType = ARRAY [1 .. MaxSortSize] OF INTEGER;
     WinnersArrayType = ARRAY [1 .. MaxWinnersSize,
                               1 .. 2] OF INTEGER;

VAR ExampleNumbers : ARRAY [0 .. 35] OF INTEGER;
    SortedIndices : ARRAY [0 .. 25] OF INTEGER;
    i : INTEGER;

FUNCTION NextPowerOfTwo (n : INTEGER) : INTEGER;
  VAR Pow2 : INTEGER;
BEGIN
  { This need not be a fast implementation. }
  Pow2 := 1;
  WHILE Pow2 < n DO
    Pow2 := Pow2 + Pow2;
  NextPowerOfTwo := Pow2;
END;

PROCEDURE InitPilesArray (VAR Arr : PilesArrayType);
  VAR i : INTEGER;
BEGIN
  FOR i := 1 TO MaxSortSize DO
    Arr[i] := 0;
END;

PROCEDURE InitWinnersArray (VAR Arr : WinnersArrayType);
  VAR i : INTEGER;
BEGIN
  FOR i := 1 TO MaxWinnersSize DO
    BEGIN
      Arr[i, 1] := 0;
      Arr[i, 2] := 0;
    END;
END;

PROCEDURE IntegerPatienceSort (iFirst, iLast : INTEGER;
                               Arr : ARRAY OF INTEGER;
                               VAR Sorted : ARRAY OF INTEGER);
  VAR NumPiles : INTEGER;
      Piles, Links : PilesArrayType;
      Winners : WinnersArrayType;

  FUNCTION FindPile (q : INTEGER) : INTEGER;
    {
       Bottenbruch search for the leftmost pile whose top is greater
       than or equal to some element x. Return an index such that:

       * if x is greater than the top element at the far right, then
         the index returned will be num-piles.

       * otherwise, x is greater than every top element to the left of
         index, and less than or equal to the top elements at index
         and to the right of index.

       References:

       * H. Bottenbruch, "Structure and use of ALGOL 60", Journal of
         the ACM, Volume 9, Issue 2, April 1962, pp.161-221.
         https://doi.org/10.1145/321119.321120

         The general algorithm is described on pages 214 and 215.

       * https://en.wikipedia.org/w/index.php?title=Binary_search_algorithm&oldid=1062988272#Alternative_procedure
    }
    VAR i, j, k, Index : INTEGER;
  BEGIN
    IF NumPiles = 0 THEN
      Index := 1
    ELSE
      BEGIN
        j := 0;
        k := NumPiles - 1;
        WHILE j <> k DO
          BEGIN
            i := (j + k) DIV 2;
            IF Arr[Piles[j + 1] + iFirst - 1] < Arr[q + iFirst - 1] THEN
              j := i + 1
            ELSE
              k := i
          END;
        IF j = NumPiles - 1 THEN
          BEGIN
            IF Arr[Piles[j + 1] + iFirst - 1] < Arr[q + iFirst - 1] THEN
              { A new pile is needed. }
              j := j + 1
          END;
        Index := j + 1
      END;
    FindPile := Index
  END;

  PROCEDURE Deal;
    VAR i, q : INTEGER;
  BEGIN
    FOR q := 1 TO iLast - iFirst + 1 DO
      BEGIN
        i := FindPile (q);
        Links[q] := Piles[i];
        Piles[i] := q;
        IF i = NumPiles + 1 THEN
          NumPiles := i
      END
  END;

  PROCEDURE KWayMerge;
    {
       k-way merge by tournament tree.

       See Knuth, volume 3, and also
       https://en.wikipedia.org/w/index.php?title=K-way_merge_algorithm&oldid=1047851465#Tournament_Tree

       However, I store a winners tree instead of the recommended
       losers tree. If the tree were stored as linked nodes, it would
       probably be more efficient to store a losers tree. However, I
       am storing the tree as an array, and one can find an opponent
       quickly by simply toggling the least significant bit of a
       competitor's array index.
    }
    VAR TotalExternalNodes : INTEGER;
        TotalNodes : INTEGER;
        iSorted, i, Next : INTEGER;

    FUNCTION FindOpponent (i : INTEGER) : INTEGER;
      VAR Opponent : INTEGER;
    BEGIN
      IF ODD (i) THEN
        Opponent := i - 1
      ELSE
        Opponent := i + 1;
      FindOpponent := Opponent
    END;

    FUNCTION PlayGame (i : INTEGER) : INTEGER;
      VAR j, iWinner : INTEGER;
    BEGIN
      j := FindOpponent (i);
      IF Winners[i, 1] = 0 THEN
        iWinner := j
      ELSE IF Winners[j, 1] = 0 THEN
        iWinner := i
      ELSE IF (Arr[Winners[j, 1] + iFirst - 1]
               < Arr[Winners[i, 1] + iFirst - 1]) THEN
        iWinner := j
      ELSE
        iWinner := i;
      PlayGame := iWinner
    END;

    PROCEDURE ReplayGames (i : INTEGER);
      VAR j, iWinner : INTEGER;
    BEGIN
      j := i;
      WHILE j <> 1 DO
        BEGIN
          iWinner := PlayGame (j);
          j := j DIV 2;
          Winners[j, 1] := Winners[iWinner, 1];
          Winners[j, 2] := Winners[iWinner, 2];
        END
    END;

    PROCEDURE BuildTree;
      VAR iStart, i, iWinner : INTEGER;
    BEGIN
      FOR i := 1 TO TotalExternalNodes DO
        { Record which pile a winner will have come from. }
        Winners[TotalExternalNodes - 1 + i, 2] := i;

      FOR i := 1 TO NumPiles DO
        { The top of each pile becomes a starting competitor. }
        Winners[TotalExternalNodes + i - 1, 1] := Piles[i];

      FOR i := 1 TO NumPiles DO
        { Discard the top of each pile. }
        Piles[i] := Links[Piles[i]];

      iStart := TotalExternalNodes;
      WHILE iStart <> 1 DO
        BEGIN
          i := iStart;
          WHILE i <= (2 * iStart) - 1 DO
            BEGIN
              iWinner := PlayGame (i);
              Winners[i DIV 2, 1] := Winners[iWinner, 1];
              Winners[i DIV 2, 2] := Winners[iWinner, 2];
              i := i + 2
            END;
          iStart := iStart DIV 2
        END
    END;

  BEGIN
    TotalExternalNodes := NextPowerOfTwo (NumPiles);
    TotalNodes := (2 * TotalExternalNodes) - 1;
    BuildTree;
    iSorted := 0;
    WHILE Winners[1, 1] <> 0 DO
      BEGIN
        Sorted[iSorted] := Winners[1, 1] + iFirst - 1;
        iSorted := iSorted + 1;
        i := Winners[1, 2];
        Next := Piles[i];         { The next top of pile i. }
        IF Next <> 0 THEN
          Piles[i] := Links[Next]; { Drop that top. }
        i := (TotalNodes DIV 2) + i;
        Winners[i, 1] := Next;
        ReplayGames (i)
      END
  END;

BEGIN
  NumPiles := 0;
  InitPilesArray (Piles);
  InitPilesArray (Links);
  InitWinnersArray (Winners);

  IF MaxSortSize < iLast - iFirst + 1 THEN
    BEGIN
      Write ('This subarray is too large for the program.');
      WriteLn;
      HALT
    END
  ELSE
    BEGIN
      Deal;
      KWayMerge
    END
END;

BEGIN
  ExampleNumbers[10] := 22;
  ExampleNumbers[11] := 15;
  ExampleNumbers[12] := 98;
  ExampleNumbers[13] := 82;
  ExampleNumbers[14] := 22;
  ExampleNumbers[15] := 4;
  ExampleNumbers[16] := 58;
  ExampleNumbers[17] := 70;
  ExampleNumbers[18] := 80;
  ExampleNumbers[19] := 38;
  ExampleNumbers[20] := 49;
  ExampleNumbers[21] := 48;
  ExampleNumbers[22] := 46;
  ExampleNumbers[23] := 54;
  ExampleNumbers[24] := 93;
  ExampleNumbers[25] := 8;
  ExampleNumbers[26] := 54;
  ExampleNumbers[27] := 2;
  ExampleNumbers[28] := 72;
  ExampleNumbers[29] := 84;
  ExampleNumbers[30] := 86;
  ExampleNumbers[31] := 76;
  ExampleNumbers[32] := 53;
  ExampleNumbers[33] := 37;
  ExampleNumbers[34] := 90;

  IntegerPatienceSort (10, 34, ExampleNumbers, SortedIndices);

  Write ('unsorted  ');
  FOR i := 10 TO 34 DO
    BEGIN
      Write (' ');
      Write (ExampleNumbers[i])
    END;
  WriteLn;
  Write ('sorted    ');
  FOR i := 0 TO 24 DO
    BEGIN
      Write (' ');
      Write (ExampleNumbers[SortedIndices[i]]);
    END;
  WriteLn
END.
