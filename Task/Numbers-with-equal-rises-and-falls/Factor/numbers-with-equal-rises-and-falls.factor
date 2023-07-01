USING: grouping io kernel lists lists.lazy math math.extras
prettyprint tools.memory.private ;

: rises-and-falls-equal? ( n -- ? )
    0 swap 10 /mod swap
    [ 10 /mod rot over - sgn rotd + spin ] until-zero drop 0 = ;

: OEIS:A296712 ( -- list )
    1 lfrom [ rises-and-falls-equal? ] lfilter ;

! Task
"The first 200 numbers in OEIS:A296712 are:" print
200 OEIS:A296712 ltake list>array 20 group simple-table. nl

"The 10 millionth number in OEIS:A296712 is " write
9,999,999 OEIS:A296712 lnth commas print
