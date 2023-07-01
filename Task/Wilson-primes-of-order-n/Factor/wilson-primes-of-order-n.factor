USING: formatting infix io kernel literals math math.functions
math.primes math.ranges prettyprint sequences sequences.extras ;

<< CONSTANT: limit 11,000 >>

CONSTANT: primes $[ limit primes-upto ]

CONSTANT: factorials
    $[ limit [1,b] 1 [ * ] accumulate* 1 prefix ]

: factorial ( n -- n! ) factorials nth ; inline

INFIX:: fn ( p n -- m )
    factorial(n-1) * factorial(p-n) - -1**n ;

: wilson? ( p n -- ? ) [ fn ] keepd sq divisor? ; inline

: order ( n -- seq )
    primes swap [ [ < ] curry drop-while ] keep
    [ wilson? ] curry filter ;

: order. ( n -- )
    dup "%2d:  " printf order [ pprint bl ] each nl ;

" n:  Wilson primes\n--------------------" print
11 [1,b] [ order. ] each
