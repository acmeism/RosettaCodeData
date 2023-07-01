USING: io kernel lists lists.lazy math.ranges math.text.utils
math.vectors prettyprint sequences ;

: disarium? ( n -- ? )
    dup 1 digit-groups dup length 1 [a,b] v^ sum = ;

: disarium ( -- list ) 0 lfrom [ disarium? ] lfilter ;

19 disarium ltake [ pprint bl ] leach nl
