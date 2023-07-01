: .bounds ( u1 u2 -- )  ." lower bound = " .  ."  upper bound = " 1- .  cr ;
: init-bins ( n -- addr )
   cells dup allocate throw  tuck swap erase ;
: expected ( u1 cnt -- u2 )  over 2/ + swap / ;
: calc-limits ( n cnt pct -- low high )
   >r  expected  r>  over 100 */ 2dup  + 1+ >r  -  r> ;
: make-histogram ( bins xt cnt -- )
   0 ?do 2dup  execute 1- cells  +  1 swap +!  loop  2drop ;
: valid-bin? ( addr n low high -- f )
   2>r  cells + @ dup .  2r> within ;

: check-distribution {: xt cnt n pct -- f :}
\ assumes xt generates numbers from 1 to n
   n init-bins  {: bins :}
   n cnt pct calc-limits  {: low high :}
   high low .bounds
   bins xt cnt make-histogram
   true  \ result flag
   n 0 ?do
      i 1+ . ." : "  bins i low high valid-bin?
      dup 0= if ." not " then ." ok" cr
      and
   loop
   bins free throw ;
