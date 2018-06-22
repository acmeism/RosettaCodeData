USING: math.parser math.primes.factors math.ranges ;
IN: scratchpad "1: 1" print 2 20 [a,b] [ dup pprint ": " write factors [ number>string ] map " x " join print ] each
