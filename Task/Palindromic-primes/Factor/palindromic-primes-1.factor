USING: kernel math.primes present prettyprint sequences ;

1000 primes-upto [ present dup reverse = ] filter stack.
