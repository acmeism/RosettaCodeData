USING: lists lists.lazy math.bitwise math.primes math.ranges
prettyprint sequences ;

: pernicious? ( n -- ? ) bit-count prime? ;

25 0 lfrom [ pernicious? ] lfilter ltake list>array .    ! print first 25 pernicious numbers
888,888,877 888,888,888 [a,b] [ pernicious? ] filter .   ! print pernicious numbers in range
