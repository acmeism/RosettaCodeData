##
uses school;

var primenumbers := firstprimes(1000);
primes(3000).where(x -> 2 * x + 1 in primenumbers).take(50).println;
