USING: io kernel math math.primes prettyprint ;

"Frobenius numbers < 10,000:" print
2 3 [
    [ nip dup next-prime ] [ * ] [ [ - ] dip - ] 2tri
    dup 10,000 <
] [ . ] while 3drop
