require random.fs
here seed !

1000000 constant rounds
variable wins
variable car
variable firstPick
variable revealed
defer applyStrategy

: isCar		( u - f )  car @ = ;
: remaining	( u u - u )  3 swap - swap - ;
: setup		3 random car ! ;
: choose	3 random firstPick ! ;
: otherGoat	( - u )  car @ firstPick @ remaining ;
: randomGoat	( - u )  car @ 1+ 2 random + 3 mod ;
: reveal	firstPick @ isCar IF randomGoat ELSE otherGoat THEN revealed ! ;
: keep		( - u )  firstPick @ ;
: switch	( - u )  firstPick @ revealed @ remaining ;
: open		( u - f )  isCar ;
: play		( - f )  setup choose reveal applyStrategy open ;
: record	( f )  1 and wins +! ;
: run 		0 wins !  rounds 0 ?DO play record LOOP ;
: result	wins @ 0 d>f  rounds 0 d>f  f/  100e f* ;
: .result	result f. '%' emit ;

' keep IS applyStrategy    run  ." Keep door   => " .result cr
' switch IS applyStrategy  run  ." Switch door => " .result cr
bye
