 Alternative Forth methodology
\ create words to describe and solve the problem
HEX
: toUpper ( char -- char ) 05F and ;

DECIMAL
\ status holders
variable oldndx
variable curndx
variable negcnt

\ word to compile a quote delimtited string into memory
: ,"   ( -- )  [char] " word C@ 1+ allot ;

\ look-up tables place into memory
create numerals  ," IVXLCDM"
create values    0 , 1 , 5 , 10 , 50 , 100 , 500 , 1000 ,

\ define words to describe/solve the problem
: init     ( -- )           curndx off  oldndx off  negcnt off ;
: toindex  ( char -- indx)  toUpper numerals count rot SCAN dup 0= abort" invalid numeral" ;
: tovalue  ( ndx -- n )     cells  values + @ ;
: remember ( ndx -- ndx )   curndx @ oldndx !  dup curndx !  ;
: memory@   ( -- n1 n2 )    curndx @ oldndx @ ;
: numval   ( char -- n )    toindex remember tovalue ;
: ?illegal ( ndx --  )      memory@ =  negcnt @ and abort" illegal format" ;

\ logic
: negate?  ( n -- +/- n )
           memory@ <
           if   negcnt on
                negate
           else
                ?illegal
                negcnt off
           then ;

\ solution
: decode   ( c-addr -- n )
           init
           0              \ accumulator on the stack
           swap
           count 1- bounds swap
           do   i c@ numval negate? +   -1 +loop ;.
