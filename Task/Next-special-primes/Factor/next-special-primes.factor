USING: formatting io kernel math math.primes ;

"2 " write 1 3
[ dup 1050 < ] [
    2dup "(%d) %d " printf [ + next-prime ] keep 2dup - nip swap
] while 2drop nl
