USING: formatting fry grouping kernel math.combinatorics
math.parser math.primes sequences ;

: partition ( x n -- str )
    over [ primes-upto ] 2dip '[ sum _ = ] find-combination
    [ number>string ] map "+" join ;

: print-partition ( x n seq -- )
    [ "no solution" ] when-empty
    "Partitioned %5d with %2d primes: %s\n" printf ;

{ 99809 1 18 2 19 3 20 4 2017 24 22699 1 22699 2 22699 3 22699
  4 40355 3 } 2 group
[ first2 2dup partition print-partition ] each
