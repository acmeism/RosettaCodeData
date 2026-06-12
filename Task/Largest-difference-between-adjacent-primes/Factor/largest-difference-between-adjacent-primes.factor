USING: arrays formatting kernel lists lists.lazy math math.order
math.primes.lists sequences ;

lprimes dup cdr lzip [ first2 2dup swap - -rot 3array ] lmap-lazy
[ second 1e6 < ] lwhile { 0 } [ max ] foldl

"Largest difference in adjacent primes under a million: %d between %d and %d.\n" vprintf
