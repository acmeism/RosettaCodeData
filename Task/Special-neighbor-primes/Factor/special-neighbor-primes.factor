USING: kernel lists lists.lazy math math.primes
math.primes.lists prettyprint sequences ;

lprimes dup cdr lzip [ sum 1 - prime? ] lfilter
[ second 100 < ] lwhile [ . ] leach
