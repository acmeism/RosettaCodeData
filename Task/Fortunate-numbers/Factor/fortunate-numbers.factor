USING: grouping io kernel math math.factorials math.primes
math.ranges prettyprint sequences sets sorting ;

"First 50 distinct fortunate numbers:" print
75 [1,b] [
    primorial dup next-prime 2dup - abs 1 =
    [ next-prime ] when - abs
] map members natural-sort 50 head 10 group simple-table.
