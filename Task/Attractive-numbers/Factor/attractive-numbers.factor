USING: formatting grouping io math.primes math.primes.factors
math.ranges sequences ;

"The attractive numbers up to and including 120 are:" print
120 [1,b] [ factors length prime? ] filter 20 <groups>
[ [ "%4d" printf ] each nl ] each
