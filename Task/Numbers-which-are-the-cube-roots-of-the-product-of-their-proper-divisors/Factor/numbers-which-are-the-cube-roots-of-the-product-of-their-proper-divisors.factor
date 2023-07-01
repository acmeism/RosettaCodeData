USING: formatting grouping io kernel lists lists.lazy math
prettyprint project-euler.common ;

: A111398 ( -- list )
    L{ 1 } 2 lfrom [ tau 8 = ] lfilter lappend-lazy ;

50 A111398 ltake list>array 10 group simple-table. nl
499 4999 49999
[ [ 1 + ] keep A111398 lnth "%5dth: %d\n" printf ] tri@
