USING: grouping math math.primes.factors math.statistics
prettyprint ranges sequences ;

2 100 [a..b] [ factors minmax * ] map 1 prefix 10 group simple-table.
