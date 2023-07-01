USING: grouping grouping.extras math math.combinatorics
math.functions math.primes math.ranges prettyprint sequences
sequences.extras ;

9 1 [a,b] all-subsets [ reverse 0 [ 10^ * + ] reduce-index ]
[ prime? ] map-filter 10 "" pad-groups 10 group simple-table.
