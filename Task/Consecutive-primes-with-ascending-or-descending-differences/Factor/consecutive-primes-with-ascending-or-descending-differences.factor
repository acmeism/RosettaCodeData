USING: arrays assocs formatting grouping io kernel literals math
math.primes math.statistics sequences sequences.extras
tools.memory.private ;

<< CONSTANT: limit 1,000,000 >>

CONSTANT: primes $[ limit primes-upto ]

: run ( n quot -- seq quot )
    [ primes ] [ <clumps> ] [ ] tri*
    '[ differences _ monotonic? ] ; inline

: max-run ( quot -- n )
    1 swap '[ 1 + dup _ run find drop ] loop 1 - ; inline

: runs ( quot -- seq )
    [ max-run ] keep run filter ; inline

: .run ( seq -- )
    dup differences [ [ commas ] map ] bi@
    [ "(" ")" surround ] map 2array round-robin " " join print ;

: .runs ( quot -- )
    [ runs ] keep [ < ] = "rising" "falling" ? limit commas
    "Largest run(s) of %s gaps between primes less than %s:\n"
    printf [ .run ] each ; inline

[ < ] [ > ] [ .runs nl ] bi@
