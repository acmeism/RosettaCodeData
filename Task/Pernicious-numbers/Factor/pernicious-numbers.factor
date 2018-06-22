USING: lists lists.lazy math.bits math.primes math.ranges ;

: pernicious? ( n -- ? ) make-bits [ t = ] count prime? ;

0 lfrom [ pernicious? ] lfilter 25 swap ltake list>array . ! print first 25 pernicious numbers
888,888,877 888,888,888 [a,b] [ pernicious? ] filter .     ! print pernicious numbers in range
