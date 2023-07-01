USING: assocs grouping io kernel lists lists.lazy math
math.functions math.primes.factors prettyprint sequences
sequences.extras ;

: tau ( n -- count ) group-factors values [ 1 + ] map-product ;

: tau? ( n -- ? ) dup tau divisor? ;

: taus ( -- list ) 1 lfrom [ tau? ] lfilter ;

! Task
"The first 100 tau numbers are:" print
100 taus ltake list>array 10 group simple-table.
