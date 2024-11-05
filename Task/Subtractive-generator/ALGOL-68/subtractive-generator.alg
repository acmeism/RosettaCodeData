BEGIN # subtractive generator - translated from the C/EasyLang samples #
   INT modulus   = 1 000 000 000;
   INT max state = 55;
   [ 0 : max state - 1 ]INT state;
   INT sgi := 0, sgj := 0;

   PROC subrand seed = ( INT p1in )VOID: BEGIN
      INT p1 := p1in, p2 := 1;
      state[ 0 ] := p1 MOD modulus;
      INT j := 21; # not sure how 21 is chosen, though it is coprime to max state #
      TO max state - 1 DO
         state[ j ] := p2;
         p2 := ( p1 - p2 ) MOD modulus;
         p1 := state[ j ];
         j +:= 21 MODAB max state
      OD;
      sgi :=  0;
      sgj := 24; # the task states this value (24) should be coprime to max state #
      FROM 0 TO ( 3 * max state ) - 1 DO
         VOID( subrand )
      OD
   END;

   PROC subrand = INT: BEGIN
      IF sgi = sgj THEN
         subrand seed( 0 )
      FI;
      sgi -:= 1 MODAB max state;
      sgj -:= 1 MODAB max state;
      state[ sgi ] -:= state[ sgj ] MODAB modulus
   END;

   subrand seed( 292929 );
   TO 10 DO
      print( ( whole( subrand, 0 ), newline ) )
   OD
END
