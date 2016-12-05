#define ARRAY_ELEMENTS 100
PROCEDURE Main()
   LOCAL aDoors := Array( ARRAY_ELEMENTS )
   LOCAL i, j

   AFill( aDoors, .F. )
   FOR i := 1 TO ARRAY_ELEMENTS
      FOR j := i TO ARRAY_ELEMENTS STEP i
         aDoors[ j ] = ! aDoors[ j ]
      NEXT
   NEXT
   AEval( aDoors, {|e, n| QQout( Padl(n,3) + " is " + Iif(aDoors[n], "*open*", "closed" ) + "|" ), Iif( n%5 == 0, Qout(), e:=NIL) } )
   RETURN
