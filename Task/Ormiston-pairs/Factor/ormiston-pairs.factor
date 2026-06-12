USING: grouping io kernel lists lists.lazy math math.parser
math.primes.lists math.statistics prettyprint sequences ;

: ormistons ( -- list )
    lprimes dup cdr lzip
    [ first2 [ >dec histogram ] same? ] lfilter ;

"First 30 Ormiston pairs:" print
30 ormistons ltake list>array 5 group simple-table. nl

ormistons [ first 1e6 < ] lwhile llength pprint bl
"Ormiston pairs less than a million." print
