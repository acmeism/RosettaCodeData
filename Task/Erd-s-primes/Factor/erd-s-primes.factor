USING: formatting io kernel lists lists.lazy math
math.factorials math.primes math.primes.lists math.vectors
prettyprint sequences tools.memory.private ;

: facts ( -- list ) 1 lfrom [ n! ] lmap-lazy ;

: n!< ( p -- seq ) [ facts ] dip [ < ] curry lwhile list>array ;

: erdős? ( p -- ? ) dup n!< n-v [ prime? ] none? ;

: erdős ( -- list ) lprimes [ erdős? ] lfilter ;

erdős [ 2500 < ] lwhile list>array
dup length "Found  %d  Erdős primes < 2500:\n" printf
[ bl ] [ pprint ] interleave nl nl

7874 erdős lnth commas
"The 7,875th Erdős prime is %s.\n" printf
