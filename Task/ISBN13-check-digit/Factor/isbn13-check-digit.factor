USING: combinators.short-circuit formatting kernel math
math.functions math.parser math.vectors qw sequences
sequences.extras sets unicode ;

: (isbn13?) ( str -- ? )
    string>digits
    [ <evens> sum ] [ <odds> 3 v*n sum + ] bi 10 divisor? ;

: isbn13? ( str -- ? )
    "- " without
    { [ length 13 = ] [ [ digit? ] all? ] [ (isbn13?) ] } 1&& ;

qw{ 978-0596528126 978-0596528120 978-1788399081 978-1788399083 }
[ dup isbn13? "good" "bad" ? "%s: %s\n" printf ] each
