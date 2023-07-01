#define ARRAY_ELEMENTS 100
PROCEDURE Main()
   LOCAL aDoors := Array( ARRAY_ELEMENTS )

   AFill( aDoors, .F. )
   AEval( aDoors, {|e, n| aDoors[n] := e := Iif( Int(Sqrt(n))==Sqrt(n), .T., .F. ) } )
   AEval( aDoors, {|e, n| QQout( Padl(n,3) + " is " + Iif(aDoors[n], "*open*", "closed" ) + "|" ), Iif( n%5 == 0, Qout(), e:=NIL )} )
   RETURN
