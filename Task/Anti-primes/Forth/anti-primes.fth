include ./factors.fs

: max-count ( n1 n2 -- n f )
    \ n is max(n1, factor-count n2); if n is new maximum then f = true.
    \
    count-factors 2dup <
    if   nip true
    else drop false
    then ;

: .anti-primes ( n -- )
    0 1 rot  \ stack: max, candidate, count
    begin
        >r dup >r max-count
        if   r> dup . r> 1-
        else r> r>
        then swap 1+ swap
    dup 0= until drop 2drop ;

." The first 20 anti-primes are: " 20 .anti-primes cr
bye
