USING: io kernel math math.combinatorics math.functions
math.primes math.ranges present sequences sequences.cords ;

! If the digit-sum of a number is divisible by 3, so too is the number.
! The digit-sum of all n-digit pandigitals is the same.
! The digit sums for 9-, 8-, 6-, 5-, and 3-digit pandigitals are all divisible by 3.
! 1, 12, and 21 are not prime so 1- and 2-digit pandigitals don't need checked.
! Hence, we only need to check 4- and 7-digit pandigitals from biggest to smallest.

{ 4 7 } [ [1,b] <permutations> ] [ cord-append ] map-reduce
[ reverse 0 [ 10^ * + ] reduce-index prime? ] find-last nip
"The largest pandigital decimal prime is: " print
[ present write ] each nl
