BEGIN # Vogel's approximation method - translation of the EasyLang sample #
  PR read "rows.incl.a68" PR              # include row (array) utilities #
  [ 1 : 4 ]INT supply := ( 50, 60, 50, 50 );
  [ 1 : 5 ]INT demand := ( 30, 20, 70, 30, 60 );
  [,]INT costs = ( ( 16, 16, 13, 22, 17 )
                 , ( 14, 14, 13, 19, 15 )
                 , ( 19, 19, 20, 23, 50 )
                 , ( 50, 12, 50, 15, 11 )
                 );
  INT nrows = ( UPB supply + 1 ) - LWB supply;
  INT ncols = ( UPB demand + 1 ) - LWB demand;

  [ 1 : nrows ]BOOL row done; FOR i TO nrows DO row done[ i ] := FALSE OD;
  [ 1 : ncols ]BOOL col done; FOR i TO ncols DO col done[ i ] := FALSE OD;

  PROC diff = ( INT j, le, BOOL is row )[]INT: BEGIN
    INT min1 := max int, min2 := 0, minp := 0;
    FOR i TO le DO
      IF NOT IF is row THEN col done[ i ] ELSE row done[ i ] FI
      THEN # not done #
         INT c := IF is row THEN costs[ j, i ] ELSE costs[ i, j ] FI;
         IF c < min1 THEN
            min2 := min1;
            min1 := c;
            minp := i
         ELIF c < min2 THEN
            min2 := c
         FI
      FI
    OD;
    ( min2 - min1, min1, minp )
  END # diff # ;

  PROC max penalty = ( INT len1, len2, BOOL is row )[]INT: BEGIN
    INT md := - max int, pm := 0, pc := 0, mc := 0;
    FOR i TO len1 DO
      IF NOT IF is row THEN row done[ i ] ELSE col done[ i ] FI
      THEN # not done #
        []INT res = diff( i, len2, is row );
        IF res[ 1 ] > md THEN
            md := res[ 1 ];
            pm := i;
            mc := res[2];
            pc := res[3]
        FI
      FI
    OD;
    IF is row THEN
      ( pm, pc, mc, md )
    ELSE
      ( pc, pm, mc, md )
    FI
  END # max penelty # ;

  PROC nextcell = []INT: BEGIN
    []INT res1 = max penalty( nrows, ncols, TRUE  );
    []INT res2 = max penalty( ncols, nrows, FALSE );
    IF res1[ 4 ] = res2[ 4 ] THEN
      IF res1[ 3 ] < res2[ 3 ] THEN res1 ELSE res2 FI
    ELSE
      IF res1[ 4 ] > res2[ 4 ] THEN res2 ELSE res1 FI
    FI
  END # nextcell # ;

  BEGIN
    [ 1 : nrows, 1 : ncols ]INT results;
    INT supplyleft := 0;
    FOR v pos FROM LWB supply TO UPB supply DO
      supplyleft +:= supply[ v pos ];
      FOR j TO ncols DO results[ v pos, j ] := 0 OD
    OD;
    INT totalcost := 0;
    WHILE supplyleft > 0 DO
      []INT cell = nextcell;
      INT r = cell[ 1 ];
      INT c = cell[ 2 ];
      INT q = IF demand[ c ] < supply[ r ] THEN demand[ c ] ELSE supply[ r ] FI;
      IF ( demand[ c ] -:= q ) = 0 THEN
        col done[ c ] := TRUE
      FI;
      IF ( supply[ r ] -:= q ) = 0 THEN
        row done[ r ] := TRUE
      FI;
      results[ r, c ] := q;
      supplyleft     -:= q;
      totalcost      +:= q * costs[ r, c ]
    OD;
    print( ( "[", newline ) );
    FOR i TO nrows DO
      print( ( " [" ) );
      FOR j TO ncols DO
        STRING fmt := whole( results[ i, j ], 0 );
        IF ( UPB fmt + 1 ) - LWB fmt < 2 THEN " " +=: fmt FI;
        print( ( " ", fmt ) )
      OD;
      print( ( " ]", newline ) )
    OD;
    print( ( "]", newline, "Total cost: ", whole( totalcost, 0 ), newline ) )
  END
END
